namespace :graphdeck do

  desc 'Aggregate metrics'
  task :aggregate => :environment do
    puts "Get all keys from 5 minute interval"
    metrics = Metric.find_all_by_key('test')
    
    count = 0
    average = 0.0
    
    metrics.each do |metric|
      count += 1 
      average += metric.value
    end
    
    if count != 0
      puts "Calculate average"
      average /= count
    
      puts "Calculate tp50"
      tp50i = (count * 50 / 100).to_i - 1
      tp50 = metrics[tp50i].value
      
      puts "Calculate tp90"
      tp90i = (count * 90 / 100).to_i - 1
      tp90 = metrics[tp90i].value
      
      puts "Calculate tp99"
      tp99i = (count * 99 / 100).to_i - 1
      tp99 = metrics[tp99i].value
      
      puts "Calculate tp100"
      tp100i = count - 1
      tp100 = metrics[tp100i].value
    end
    
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
  end
  
end