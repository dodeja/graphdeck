namespace :graphdeck do

  desc 'Aggregate metrics'
  task :aggregate => :environment do
    STDOUT.flush
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    
    # Get all namespaces
    t0_namespaces_query = Time.now.to_i
    namespaces = Namespace.find(:all).group_by { |namespace| namespace.name }
    t1_namespaces_query = Time.now.to_i
    t_namespaces_query = t1_namespaces_query - t0_namespaces_query
    puts "Found namespaces: (#{t_namespaces_query} s)"
    namespaces.each do |name, namespace|
      puts " - #{name}"
    end

    namespaces.each do |namespace, namespace_array|
      
      namespace_id = namespace_array[0].id
      t0_metric_names_query = Time.now.to_i
      metric_names = namespace_array[0].metric_names
      t1_metric_names_query = Time.now.to_i
      t_metric_names_query = t1_metric_names_query - t0_metric_names_query
      
      puts "In namespace '#{namespace}', found metrics: (#{t_metric_names_query} s)"
      metric_names.each do |name|
        puts " - #{name}"
      end
      
      metric_names.each do |metric_name|
        t0_metric_metadata_query = Time.now.to_i
        metric_metadata = AggregateMetricMetadata.find(:first, :conditions => {:name => metric_name, :duration => 300, :namespace_id => namespace_id})
        t1_metric_metadata_query = Time.now.to_i
        t_metric_metadata_query = t1_metric_metadata_query - t0_metric_metadata_query
        
        timestamp = 0
        if metric_metadata.nil?
          puts "In namespace '#{namespace}', metric '#{metric_name}', did not find aggregate metric metadata: (#{t_metric_metadata_query} s)"
        else
          puts "In namespace '#{namespace}', metric '#{metric_name}', found aggregate metric metadata: (#{t_metric_metadata_query} s)"
          timestamp = metric_metadata.timestamp + 300
        end
        
        puts "In namespace '#{namespace}', metric '#{metric_name}', searching from timestamp #{timestamp}"
        
        t0_metric_query = Time.now.to_i
        metrics = Metric.find(:all, :conditions => {:name => metric_name, :timestamp => timestamp..Time.now.to_i, :namespace_id => namespace_id})
        grouped_metrics = metrics.group_by { |metric| metric.timestamp / 300 * 300 }
        t1_metric_query = Time.now.to_i
        t_metric_query = t1_metric_query - t0_metric_query
        
        puts "In namespace '#{namespace}', metric '#{metric_name}', found #{metrics.count} metrics and #{grouped_metrics.count} timestamp groups"
        
        t0_aggregate_metric_query = Time.now.to_i
        grouped_metrics.each do |range, metric_array|
          unless range == Time.now.to_i / 300 * 300
            count = 0
            average = 0.0
        
            metric_array.sort! { |x,y| x.value <=> y.value }.each do |metric|
              count += 1 
              average += metric.value
            end
    
            if count != 0
              average /= count
    
              tp50i = ((count-1) * 50 / 100)
              tp50 = metric_array[tp50i].value
      
              tp90i = ((count-1) * 90 / 100)
              tp90 = metric_array[tp90i].value
      
              tp99i = ((count-1) * 99 / 100)
              tp99 = metric_array[tp99i].value
      
              tp100i = count - 1
              tp100 = metric_array[tp100i].value
            end
      
            # puts "=== #{metric_name} #{range}"
            # puts "Count: " + count.to_s
            # puts "Average: " + average.to_s
            # puts "tp50i: " + tp50i.to_s
            # puts "tp50: " + tp50.to_s
            # puts "tp90i: " + tp90i.to_s
            # puts "tp90: " + tp90.to_s
            # puts "tp99i: " + tp99i.to_s
            # puts "tp99: " + tp99.to_s
            # puts "tp100i: " + tp100i.to_s
            # puts "tp100: " + tp100.to_s
            
            amcount = AggregateMetric.find(:first, :conditions => {:namespace_id => namespace_id, :name => metric_name, :timestamp => range, :duration => 300, :metric_type => AggregateMetric::COUNT})
            amaverage = AggregateMetric.find(:first, :conditions => {:namespace_id => namespace_id, :name => metric_name, :timestamp => range, :duration => 300, :metric_type => AggregateMetric::AVERAGE})
            amtp50 = AggregateMetric.find(:first, :conditions => {:namespace_id => namespace_id, :name => metric_name, :timestamp => range, :duration => 300, :metric_type => AggregateMetric::TP50})
            amtp90 = AggregateMetric.find(:first, :conditions => {:namespace_id => namespace_id, :name => metric_name, :timestamp => range, :duration => 300, :metric_type => AggregateMetric::TP90})
            amtp99 = AggregateMetric.find(:first, :conditions => {:namespace_id => namespace_id, :name => metric_name, :timestamp => range, :duration => 300, :metric_type => AggregateMetric::TP99})
            amtp100 = AggregateMetric.find(:first, :conditions => {:namespace_id => namespace_id, :name => metric_name, :timestamp => range, :duration => 300, :metric_type => AggregateMetric::TP100})
            
            problem = false
            
            if amcount.nil?
              amcount = AggregateMetric.new(:namespace_id => namespace_id, :name => metric_name, :value => count, :timestamp => range, :duration => 300, :metric_type => AggregateMetric::COUNT)
              if amcount.save
                puts "Save success"
              else
                puts "Save fail: #{amcount.errors.inspect}"
                problem = true
              end
            else
              puts "Didn't create a new aggregate metric because I already found one: #{amcount.inspect}"
            end
          
            if amaverage.nil?
              amaverage = AggregateMetric.new(:namespace_id => namespace_id, :name => metric_name, :value => average, :timestamp => range, :duration => 300, :metric_type => AggregateMetric::AVERAGE)
              if amaverage.save
                puts "Save success"
              else
                puts "Save fail: #{amaverage.errors.inspect}"
                problem = true
              end
            else
              puts "Didn't create a new aggregate metric because I already found one: #{amaverage.inspect}"
            end
          
            if amtp50.nil?
              amtp50 = AggregateMetric.new(:namespace_id => namespace_id, :name => metric_name, :value => tp50, :timestamp => range, :duration => 300, :metric_type => AggregateMetric::TP50)
              if amtp50.save
                puts "Save success"
              else
                puts "Save fail: #{amtp50.errors.inspect}"
                problem = true
              end
            else
              puts "Didn't create a new aggregate metric because I already found one: #{amtp50.inspect}"
            end
          
            if amtp90.nil?
              amtp90 = AggregateMetric.new(:namespace_id => namespace_id, :name => metric_name, :value => tp90, :timestamp => range, :duration => 300, :metric_type => AggregateMetric::TP90)
              if amtp90.save
                puts "Save success"
              else
                puts "Save fail: #{amtp90.errors.inspect}"
                problem = true
              end
            else
              puts "Didn't create a new aggregate metric because I already found one: #{amtp90.inspect}"
            end
          
            if amtp99.nil?
              amtp99 = AggregateMetric.new(:namespace_id => namespace_id, :name => metric_name, :value => tp99, :timestamp => range, :duration => 300, :metric_type => AggregateMetric::TP99)
              if amtp99.save
                puts "Save success"
              else
                puts "Save fail: #{amtp99.errors.inspect}"
                problem = true
              end
            else
              puts "Didn't create a new aggregate metric because I already found one: #{amtp99.inspect}"
            end
          
            if amtp100.nil?
              amtp100 = AggregateMetric.new(:namespace_id => namespace_id, :name => metric_name, :value => tp100, :timestamp => range, :duration => 300, :metric_type => AggregateMetric::TP100)
              if amtp100.save
                puts "Save success"
              else
                puts "Save fail: #{amtp100.errors.inspect}"
                problem = true
              end
            else
              puts "Didn't create a new aggregate metric because I already found one: #{amtp100.inspect}"
            end
            
            unless problem
              if metric_metadata.nil?
                metric_metadata = AggregateMetricMetadata.new(:namespace_id => namespace_id, :name => metric_name, :timestamp => range, :duration => 300)
                if metric_metadata.save
                  puts "Aggregate metric metadata save success"
                else
                  puts "Aggregate metric metadata save fail: #{metric_metadata.errors.inspect}"
                end
              else
                metric_metadata.timestamp = range
                if metric_metadata.save
                  puts "Aggregate metric metadata update succeed"
                else
                  puts "Aggregate metric metadata update fail: #{metric_metadata.errors.inspect}"
                end
              end
            end
          
          end
        end
        t1_aggregate_metric_query = Time.now.to_i
        t_aggregate_metric_query = t1_aggregate_metric_query - t0_aggregate_metric_query
        puts "In namespace '#{namespace}', metric '#{metric_name}', finished aggregate metric updates (#{t_aggregate_metric_query} s)"
      end
    end
  end
  
  desc 'Aggregate metrics'
  task :aggregate3600 => :environment do
    STDOUT.flush
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    
    # Get all namespaces
    t0_namespaces_query = Time.now.to_i
    namespaces = Namespace.find(:all).group_by { |namespace| namespace.name }
    t1_namespaces_query = Time.now.to_i
    t_namespaces_query = t1_namespaces_query - t0_namespaces_query
    puts "Found namespaces: (#{t_namespaces_query} s)"
    namespaces.each do |name, namespace|
      puts " - #{name}"
    end

    namespaces.each do |namespace, namespace_array|
      
      namespace_id = namespace_array[0].id
      t0_metric_names_query = Time.now.to_i
      metric_names = namespace_array[0].metric_names
      t1_metric_names_query = Time.now.to_i
      t_metric_names_query = t1_metric_names_query - t0_metric_names_query
      
      puts "In namespace '#{namespace}', found metrics: (#{t_metric_names_query} s)"
      metric_names.each do |name|
        puts " - #{name}"
      end
      
      metric_names.each do |metric_name|
        t0_metric_metadata_query = Time.now.to_i
        metric_metadata = AggregateMetricMetadata.find(:first, :conditions => {:name => metric_name, :duration => 3600, :namespace_id => namespace_id})
        t1_metric_metadata_query = Time.now.to_i
        t_metric_metadata_query = t1_metric_metadata_query - t0_metric_metadata_query
        
        timestamp = 0
        if metric_metadata.nil?
          puts "In namespace '#{namespace}', metric '#{metric_name}', did not find aggregate metric metadata: (#{t_metric_metadata_query} s)"
        else
          puts "In namespace '#{namespace}', metric '#{metric_name}', found aggregate metric metadata: (#{t_metric_metadata_query} s)"
          timestamp = metric_metadata.timestamp + 3600
        end
        
        puts "In namespace '#{namespace}', metric '#{metric_name}', searching from timestamp #{timestamp}"
        
        t0_metric_query = Time.now.to_i
        metrics = Metric.find(:all, :conditions => {:name => metric_name, :timestamp => timestamp..Time.now.to_i, :namespace_id => namespace_id})
        grouped_metrics = metrics.group_by { |metric| metric.timestamp / 3600 * 3600 }
        t1_metric_query = Time.now.to_i
        t_metric_query = t1_metric_query - t0_metric_query
        
        puts "In namespace '#{namespace}', metric '#{metric_name}', found #{metrics.count} metrics and #{grouped_metrics.count} timestamp groups"
        
        t0_aggregate_metric_query = Time.now.to_i
        grouped_metrics.each do |range, metric_array|
          unless range == Time.now.to_i / 3600 * 3600
            count = 0
            average = 0.0
        
            metric_array.sort! { |x,y| x.value <=> y.value }.each do |metric|
              count += 1 
              average += metric.value
            end
    
            if count != 0
              average /= count
    
              tp50i = ((count-1) * 50 / 100)
              tp50 = metric_array[tp50i].value
      
              tp90i = ((count-1) * 90 / 100)
              tp90 = metric_array[tp90i].value
      
              tp99i = ((count-1) * 99 / 100)
              tp99 = metric_array[tp99i].value
      
              tp100i = count - 1
              tp100 = metric_array[tp100i].value
            end
      
            # puts "=== #{metric_name} #{range}"
            # puts "Count: " + count.to_s
            # puts "Average: " + average.to_s
            # puts "tp50i: " + tp50i.to_s
            # puts "tp50: " + tp50.to_s
            # puts "tp90i: " + tp90i.to_s
            # puts "tp90: " + tp90.to_s
            # puts "tp99i: " + tp99i.to_s
            # puts "tp99: " + tp99.to_s
            # puts "tp100i: " + tp100i.to_s
            # puts "tp100: " + tp100.to_s
            
            amcount = AggregateMetric.find(:first, :conditions => {:namespace_id => namespace_id, :name => metric_name, :timestamp => range, :duration => 3600, :metric_type => AggregateMetric::COUNT})
            amaverage = AggregateMetric.find(:first, :conditions => {:namespace_id => namespace_id, :name => metric_name, :timestamp => range, :duration => 3600, :metric_type => AggregateMetric::AVERAGE})
            amtp50 = AggregateMetric.find(:first, :conditions => {:namespace_id => namespace_id, :name => metric_name, :timestamp => range, :duration => 3600, :metric_type => AggregateMetric::TP50})
            amtp90 = AggregateMetric.find(:first, :conditions => {:namespace_id => namespace_id, :name => metric_name, :timestamp => range, :duration => 3600, :metric_type => AggregateMetric::TP90})
            amtp99 = AggregateMetric.find(:first, :conditions => {:namespace_id => namespace_id, :name => metric_name, :timestamp => range, :duration => 3600, :metric_type => AggregateMetric::TP99})
            amtp100 = AggregateMetric.find(:first, :conditions => {:namespace_id => namespace_id, :name => metric_name, :timestamp => range, :duration => 3600, :metric_type => AggregateMetric::TP100})
            
            problem = false
            
            if amcount.nil?
              amcount = AggregateMetric.new(:namespace_id => namespace_id, :name => metric_name, :value => count, :timestamp => range, :duration => 3600, :metric_type => AggregateMetric::COUNT)
              if amcount.save
                puts "Save success"
              else
                puts "Save fail: #{amcount.errors.inspect}"
                problem = true
              end
            else
              puts "Didn't create a new aggregate metric because I already found one: #{amcount.inspect}"
            end
          
            if amaverage.nil?
              amaverage = AggregateMetric.new(:namespace_id => namespace_id, :name => metric_name, :value => average, :timestamp => range, :duration => 3600, :metric_type => AggregateMetric::AVERAGE)
              if amaverage.save
                puts "Save success"
              else
                puts "Save fail: #{amaverage.errors.inspect}"
                problem = true
              end
            else
              puts "Didn't create a new aggregate metric because I already found one: #{amaverage.inspect}"
            end
          
            if amtp50.nil?
              amtp50 = AggregateMetric.new(:namespace_id => namespace_id, :name => metric_name, :value => tp50, :timestamp => range, :duration => 3600, :metric_type => AggregateMetric::TP50)
              if amtp50.save
                puts "Save success"
              else
                puts "Save fail: #{amtp50.errors.inspect}"
                problem = true
              end
            else
              puts "Didn't create a new aggregate metric because I already found one: #{amtp50.inspect}"
            end
          
            if amtp90.nil?
              amtp90 = AggregateMetric.new(:namespace_id => namespace_id, :name => metric_name, :value => tp90, :timestamp => range, :duration => 3600, :metric_type => AggregateMetric::TP90)
              if amtp90.save
                puts "Save success"
              else
                puts "Save fail: #{amtp90.errors.inspect}"
                problem = true
              end
            else
              puts "Didn't create a new aggregate metric because I already found one: #{amtp90.inspect}"
            end
          
            if amtp99.nil?
              amtp99 = AggregateMetric.new(:namespace_id => namespace_id, :name => metric_name, :value => tp99, :timestamp => range, :duration => 3600, :metric_type => AggregateMetric::TP99)
              if amtp99.save
                puts "Save success"
              else
                puts "Save fail: #{amtp99.errors.inspect}"
                problem = true
              end
            else
              puts "Didn't create a new aggregate metric because I already found one: #{amtp99.inspect}"
            end
          
            if amtp100.nil?
              amtp100 = AggregateMetric.new(:namespace_id => namespace_id, :name => metric_name, :value => tp100, :timestamp => range, :duration => 3600, :metric_type => AggregateMetric::TP100)
              if amtp100.save
                puts "Save success"
              else
                puts "Save fail: #{amtp100.errors.inspect}"
                problem = true
              end
            else
              puts "Didn't create a new aggregate metric because I already found one: #{amtp100.inspect}"
            end
            
            unless problem
              if metric_metadata.nil?
                metric_metadata = AggregateMetricMetadata.new(:namespace_id => namespace_id, :name => metric_name, :timestamp => range, :duration => 3600)
                if metric_metadata.save
                  puts "Aggregate metric metadata save success"
                else
                  puts "Aggregate metric metadata save fail: #{metric_metadata.errors.inspect}"
                end
              else
                metric_metadata.timestamp = range
                if metric_metadata.save
                  puts "Aggregate metric metadata update succeed"
                else
                  puts "Aggregate metric metadata update fail: #{metric_metadata.errors.inspect}"
                end
              end
            end
          
          end
        end
        t1_aggregate_metric_query = Time.now.to_i
        t_aggregate_metric_query = t1_aggregate_metric_query - t0_aggregate_metric_query
        puts "In namespace '#{namespace}', metric '#{metric_name}', finished aggregate metric updates (#{t_aggregate_metric_query} s)"
      end
    end
  end
  
end