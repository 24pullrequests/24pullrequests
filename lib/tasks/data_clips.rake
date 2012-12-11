desc 'Pull data clip JSON'
task :download_data_clips => :environment do
  DataClip.predefined.each do |c|
    data = RestClient.get "#{c[:url]}.json"
    clip = DataClip.find_or_create_by_url(c[:url])
    clip.update_attributes(:title => c[:title], :json => data, :chart_type => c[:chart_type])
  end
end