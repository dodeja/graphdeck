namespace :graphdeck do

  desc 'Aggregate metrics'
  task :aggregate => :environment do
    puts "Get all names from 5 minute interval"
    t0_namespaces_query = Time.now.to_i
    namespaces = Namespace.find(:all).group_by { |namespace| namespace.name }
    t1_namespaces_query = Time.now.to_i
    t_namespaces_query = t1_namespaces_query - t0_namespaces_query
    puts "Timing: t_namespaces_query:#{t_namespaces_query}"

    namespaces.each do |namespace, namespace_array|
      namespace_id = namespace_array[0].id
      t0_metric_names_query = Time.now.to_i
      metric_names = namespace_array[0].metric_names
      t1_metric_names_query = Time.now.to_i
      t_metric_names_query = t1_metric_names_query - t0_metric_names_query
      puts "Timing: namespace:#{namespace} t_metric_names_query:#{t_metric_names_query}"
      metric_names.each do |metric_name|
        t0_metric_query = Time.now.to_i
        metrics = Metric.find(:all, :conditions => {:name => metric_name, :namespace_id => namespace_id}).group_by { |metric| metric.timestamp / 300 * 300 }
        t1_metric_query = Time.now.to_i
        t_metric_query = t1_metric_query - t0_metric_query
        puts "Timing: namespace:#{namespace} metric_name:#{metric_name} t_metric_query:#{t_metric_query}"
        
        t0_aggregate_metric_query = Time.now.to_i
        metrics.each do |range, metric_array|
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
      
            puts "=== #{metric_name} #{range}"
            puts "Count: " + count.to_s
            puts "Average: " + average.to_s
          
            puts "tp50i: " + tp50i.to_s
            puts "tp50: " + tp50.to_s
            puts "tp90i: " + tp90i.to_s
            puts "tp90: " + tp90.to_s
            puts "tp99i: " + tp99i.to_s
            puts "tp99: " + tp99.to_s
            puts "tp100i: " + tp100i.to_s
            puts "tp100: " + tp100.to_s

            amcount = AggregateMetric.find(:first, :conditions => {:namespace_id => namespace_id, :name => metric_name, :timestamp => range, :duration => 300, :metric_type => AggregateMetric::COUNT})
            amaverage = AggregateMetric.find(:first, :conditions => {:namespace_id => namespace_id, :name => metric_name, :timestamp => range, :duration => 300, :metric_type => AggregateMetric::AVERAGE})
            amtp50 = AggregateMetric.find(:first, :conditions => {:namespace_id => namespace_id, :name => metric_name, :timestamp => range, :duration => 300, :metric_type => AggregateMetric::TP50})
            amtp90 = AggregateMetric.find(:first, :conditions => {:namespace_id => namespace_id, :name => metric_name, :timestamp => range, :duration => 300, :metric_type => AggregateMetric::TP90})
            amtp99 = AggregateMetric.find(:first, :conditions => {:namespace_id => namespace_id, :name => metric_name, :timestamp => range, :duration => 300, :metric_type => AggregateMetric::TP99})
            amtp100 = AggregateMetric.find(:first, :conditions => {:namespace_id => namespace_id, :name => metric_name, :timestamp => range, :duration => 300, :metric_type => AggregateMetric::TP100})
            if amcount.nil?
              amcount = AggregateMetric.new(:namespace_id => namespace_id, :name => metric_name, :value => count, :timestamp => range, :duration => 300, :metric_type => AggregateMetric::COUNT)
              if amcount.save
                puts "Save success"
              else
                puts "Save fail: #{amcount.errors.inspect}"
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
              end
            else
              puts "Didn't create a new aggregate metric because I already found one: #{amtp100.inspect}"
            end
          
          end
        end
        t1_aggregate_metric_query = Time.now.to_i
        t_aggregate_metric_query = t1_aggregate_metric_query - t0_aggregate_metric_query
        puts "Timing: namespace:#{namespace} metric_name:#{metric_name} t_aggregate_metric_query:#{t_aggregate_metric_query}"
      end
    end
  end
  
end