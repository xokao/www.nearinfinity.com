require 'disqussion'
require 'faraday'
require 'json'

# Check environment variables
if !ENV['DISQUS_API_KEY']
  puts "Could not find DISQUS_API_KEY environment variable"
  exit(0)
end

if !ENV['DISQUS_API_SECRET']
  puts "Could not find DISQUS_API_SECRET environment variable"
  exit(0)
end

if !ENV['NIC_DB_API_NAME']
  puts "Could not find NIC_DB_API_NAME environment variable"
  exit(0)
end

if !ENV['NIC_DB_API_KEY']
  puts "Could not find NIC_DB_API_KEY environment variable"
  exit(0)
end

# Get employee information
response = Faraday.get "http://www.nearinfinity.com/employee_map.json"
if !response.success?
  puts "Error retrieving employee map from NIC website"
  exit(0)
end
employees = JSON.parse(response.body)

connection = Faraday::Connection.new('https://nic-util01.nearinfinity.com',
                                     :ssl => {:ca_file => 'nearinfinity-NIC-AD01-CA.pem'})
response = connection.get "/nic/service/employee/numbers_and_email_addresses?shared_key=" + ENV['NIC_DB_API_KEY'] + "&name=" + ENV['NIC_DB_API_NAME']
if !response.success?
  puts "Error retrieving employee email addresses from Dave's Employee Database"
  exit(0)
end
email_addresses = JSON.parse(response.body)

Disqussion.configure do |config|
  config.api_key = ENV['DISQUS_API_KEY']
  config.api_secret = ENV['DISQUS_API_SECRET']
end

# Get all threads from Disqus
response = Disqussion::Client.threads.list({
  :forum => "nearinfinity",
  :limit => 100,
  :order => "asc"
}).response

threads = []

while response.length > 1 do
  threads.concat(response[1..response.length-1])

  response = Disqussion::Client.threads.list({
    :forum => "nearinfinity",
    :limit => 100,
    :order => "asc",
    :since => response.last.created_at
  }).response
end

# Filter threads and subscribe employees to the threads they own
threads.each do |thread|
  if !thread.link || !thread.link.start_with?("http://www.nearinfinity.com/blogs/")
    next
  end

  right = thread.link[34..thread.link.length-1]
  blog_name = right[0..right.index('/')-1]
  employee = employees.select{|employee| employee['blog_name'] == blog_name}.first
  if !employee
    puts "Could not find employee " + blog_name
    next
  end

  employee_number = employee['employee_number']
  email_address = email_addresses[employee_number.to_s]

  if !email_address
    puts "Could not find email address for employee " + employee_number
    next
  end

  response = Disqussion::Client.threads.unsubscribe({
    :thread => thread.id,
    :email => email_address
  })
  if response.code != 0
    puts "Error subscribing " + email_address + " to " + thread.link
    next
  end

  puts "Subscribed " + email_address + " to " + thread.link
end

puts "Done subscribing employees to their blogs on Disqus"
