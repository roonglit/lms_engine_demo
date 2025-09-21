# Engine CSS tasks restored for development convenience
# Note: In production, main app (onerev) generates complete CSS including engine classes

namespace :lms do
  namespace :tailwindcss do
    desc "Watch and build LMS Tailwind CSS on file changes"
    task :watch do
      input_file, output_file = setup_lms_tailwind_files
      
      puts "Watching LMS Tailwind CSS: #{input_file} -> #{output_file}"
      puts "Press Ctrl+C to stop watching..."
      
      exec_lms_tailwind_command(input_file, output_file, "--watch")
    rescue Interrupt
      puts "\nStopping LMS Tailwind CSS watcher..."
    end
    
    desc "Build LMS Tailwind CSS"
    task :build do
      input_file, output_file = setup_lms_tailwind_files
      
      puts "Building: #{input_file} -> #{output_file}"
      
      if exec_lms_tailwind_command(input_file, output_file)
        puts "LMS Tailwind CSS built successfully!"
      else
        puts "Error building LMS Tailwind CSS"
        exit 1
      end
    end
  end

  namespace :dummy do
    namespace :admin do
      namespace :tailwindcss do
        desc "Watch and build LMS dummy admin Tailwind CSS on file changes"
        task :watch do
          input_file, output_file = setup_dummy_admin_tailwind_files
          
          puts "Watching LMS dummy admin Tailwind CSS: #{input_file} -> #{output_file}"
          puts "Scanning dummy app files only (like onerev standalone app)"
          puts "Press Ctrl+C to stop watching..."
          
          exec_dummy_tailwind_command(input_file, output_file, "--watch")
        rescue Interrupt
          puts "\nStopping LMS dummy admin Tailwind CSS watcher..."
        end
        
        desc "Build LMS dummy admin Tailwind CSS"
        task :build do
          input_file, output_file = setup_dummy_admin_tailwind_files
          
          puts "Building: #{input_file} -> #{output_file}"
          puts "Scanning dummy app files only (like onerev standalone app)"
          
          if exec_dummy_tailwind_command(input_file, output_file)
            puts "LMS dummy admin Tailwind CSS built successfully!"
          else
            puts "Error building LMS dummy admin Tailwind CSS"
            exit 1
          end
        end
      end
    end
  end
end

# Helper methods
def setup_lms_tailwind_files
  engine_root = File.expand_path("../..", __dir__)
  input_file = File.join(engine_root, "app/assets/tailwind/lms/admin.css")
  output_file = File.join(engine_root, "app/assets/builds/lms/admin/tailwind.css")
  
  # Ensure directories exist
  FileUtils.mkdir_p(File.dirname(input_file))
  FileUtils.mkdir_p(File.dirname(output_file))
  
  # Create input file if it doesn't exist
  unless File.exist?(input_file)
    File.write(input_file, <<~CSS)
      @import "tailwindcss";
      
      /* LMS Engine-specific styles */
    CSS
    puts "Created #{input_file}"
  end
  
  [input_file, output_file]
end

def setup_dummy_admin_tailwind_files
  engine_root = File.expand_path("../..", __dir__)
  input_file = File.join(engine_root, "test/dummy/app/assets/tailwind/admin.css")
  output_file = File.join(engine_root, "test/dummy/app/assets/builds/admin/tailwind.css")
  
  # Ensure directories exist
  FileUtils.mkdir_p(File.dirname(input_file))
  FileUtils.mkdir_p(File.dirname(output_file))
  
  # Create input file if it doesn't exist
  unless File.exist?(input_file)
    File.write(input_file, <<~CSS)
      @import "tailwindcss";
      
      /* LMS Dummy Admin-specific styles */
    CSS
    puts "Created #{input_file}"
  end
  
  [input_file, output_file]
end

def exec_lms_tailwind_command(input_file, output_file, *options)
  # Engine CSS generation for development purposes
  cmd = [
    "tailwindcss",
    "-i", input_file.to_s,
    "-o", output_file.to_s,
    *options
  ]
  
  puts "Building LMS engine CSS with Tailwind CSS v4 default content scanning" if ENV['DEBUG']
  
  if options.include?("--watch")
    exec(*cmd)
  else
    system(*cmd)
  end
end

def exec_dummy_tailwind_command(input_file, output_file, *options)
  # Dummy app uses Tailwind's default content scanning behavior
  cmd = [
    "tailwindcss",
    "-i", input_file.to_s,
    "-o", output_file.to_s,
    *options
  ]
  
  puts "Building with Tailwind CSS v4 default content scanning" if ENV['DEBUG']
  
  if options.include?("--watch")
    exec(*cmd)
  else
    system(*cmd)
  end
end
