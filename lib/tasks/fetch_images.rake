namespace :getsavechallange do  
  task :fetch_images, [:file] => [:environment] do |_task, args|
    path_to_file = args[:file]
    FetchImagesService.new.process_file(path_to_file)
  end
end