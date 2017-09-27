require 'xcodeproj'

ENV['APP_IDENTIFIER'] = 'com.widex.appstore.xcodeproj-sample-env' 
ENV['RICK'] = 'WHAT UP MY GLIP GLOPS!'
ENV['MORTY'] = 'Dont be trippin dog we got you'

describe 'xcodeproj variables' do
  
  it "substitues variables" do
    project = Xcodeproj::Project.open('xcodeproj-sample-env.xcodeproj')
    project.targets.each do |target|
      target.build_configuration_list.build_configurations.each do |build_configuration|
        app_identifier = build_configuration.resolve_build_setting("APP_IDENTIFIER")
        bundle_identifier = build_configuration.resolve_build_setting("PRODUCT_BUNDLE_IDENTIFIER")
        expect(app_identifier).to eq(ENV['APP_IDENTIFIER'])
        expect(bundle_identifier).to eq("#{ENV['APP_IDENTIFIER']}") if target.name == 'xcodeproj-sample-env'
        expect(bundle_identifier).to eq("#{ENV['APP_IDENTIFIER']}.watchkitapp") if target.name == 'xcodeproj-sample-env-watch Extension'
        expect(bundle_identifier).to eq("#{ENV['APP_IDENTIFIER']}.watchkitapp.watchkitextension") if target.name == 'xcodeproj-sample-env-watch'
      end
    end
  end

  it "substitues debug env variables" do
    project = Xcodeproj::Project.open('xcodeproj-sample-env.xcodeproj')
    project.targets.each do |target|
      target.build_configuration_list.build_configurations.each do |build_configuration|
        debug_env = build_configuration.resolve_build_setting("DEBUG_ENV")
        expect(debug_env).to eq(ENV['RICK']) if build_configuration.name == 'Debug'
      end
    end
  end

  it "substitues release env variables" do
    project = Xcodeproj::Project.open('xcodeproj-sample-env.xcodeproj')
    project.targets.each do |target|
      target.build_configuration_list.build_configurations.each do |build_configuration|
        release_env = build_configuration.resolve_build_setting("RELEASE_ENV")
        expect(release_env).to eq(ENV['MORTY']) if build_configuration.name == 'Release'
      end
    end
  end
end