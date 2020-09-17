# README

This repo holds a ruby on rails application responding to a code challage.

The task was to

<em>Write a program with a simple command line interface that takes this plaintext file as an argument and downloads all images, storing them on the local hard disk.</em>

I used a simple rake task to accomplish this. That task `getsavechallange:fetch_images` uses a service `FetchImagesService` within a ruby on rails application. 
To get the application running call `bundle` and `rake db:migrate` first.

The program can be called from the command line with 
`rake getsavechallange:fetch_images[PATH_TO_TEXTFILE]`,
for example `rake getsavechallange:fetch_images[./input_files/images.txt]`

To test the application use
`rspec`or `rspec spec/services/fetch_images_service_spec.rb`

Thx
Simon
