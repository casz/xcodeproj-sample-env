require 'xcodeproj'

ENV['RICK'] = 'WHAT UP MY GLIP GLOPS!'
ENV['MORTY'] = 'Dont be trippin dog we got you'
normal = 'com.widex.enterprise.xcodeproj-sample-env'

describe 'xcodeproj variables' do

  it 'should still resolve xcode build settings' do
    project = Xcodeproj::Project.open('xcodeproj-sample-env.xcodeproj')
    project.targets.each do |target|
      target.build_configuration_list.build_configurations.each do |build_configuration|
        app_identifier = build_configuration.resolve_build_setting('APP_IDENTIFIER')
        bundle_identifier = build_configuration.resolve_build_setting('PRODUCT_BUNDLE_IDENTIFIER')
        expect(app_identifier).to eq(normal)
      end
    end
  end

  it 'subtitues variables that are resolved by xcode build settings' do
    project = Xcodeproj::Project.open('xcodeproj-sample-env.xcodeproj')
    project.targets.each do |target|
      target.build_configuration_list.build_configurations.each do |build_configuration|
        app_identifier = build_configuration.resolve_build_setting('APP_IDENTIFIER')
        bundle_identifier = build_configuration.resolve_build_setting('PRODUCT_BUNDLE_IDENTIFIER')
        expect(app_identifier).to eq(normal)
        expect(bundle_identifier).to eq(normal) if target.name == 'xcodeproj-sample-env'
        expect(bundle_identifier).to eq("#{normal}.watchkitapp") if target.name == 'xcodeproj-sample-env-watch Extension'
        expect(bundle_identifier).to eq("#{normal}.watchkitapp.watchkitextension") if target.name == 'xcodeproj-sample-env-watch'
      end
    end
  end

  it 'substitues bundle identifiers variable' do
    ENV['APP_IDENTIFIER'] = 'com.widex.appstore.xcodeproj-sample-env'
    project = Xcodeproj::Project.open('xcodeproj-sample-env.xcodeproj')
    project.targets.each do |target|
      target.build_configuration_list.build_configurations.each do |build_configuration|
        app_identifier = build_configuration.resolve_build_setting('APP_IDENTIFIER')
        bundle_identifier = build_configuration.resolve_build_setting('PRODUCT_BUNDLE_IDENTIFIER')
        expect(app_identifier).to eq(ENV['APP_IDENTIFIER'])
        expect(bundle_identifier).to eq((ENV['APP_IDENTIFIER']).to_s) if target.name == 'xcodeproj-sample-env'
        expect(bundle_identifier).to eq("#{ENV['APP_IDENTIFIER']}.watchkitapp") if target.name == 'xcodeproj-sample-env-watch Extension'
        expect(bundle_identifier).to eq("#{ENV['APP_IDENTIFIER']}.watchkitapp.watchkitextension") if target.name == 'xcodeproj-sample-env-watch'
      end
    end
  end

  it 'substitues debug env variable' do
    project = Xcodeproj::Project.open('xcodeproj-sample-env.xcodeproj')
    project.targets.each do |target|
      target.build_configuration_list.build_configurations.each do |build_configuration|
        debug_env = build_configuration.resolve_build_setting('DEBUG_ENV')
        expect(debug_env).to eq(ENV['RICK']) if build_configuration.name == 'Debug'
      end
    end
  end

  it 'substitues release env variable' do
    project = Xcodeproj::Project.open('xcodeproj-sample-env.xcodeproj')
    project.targets.each do |target|
      target.build_configuration_list.build_configurations.each do |build_configuration|
        release_env = build_configuration.resolve_build_setting('RELEASE_ENV')
        expect(release_env).to eq(ENV['MORTY']) if build_configuration.name == 'Release'
      end
    end
  end
end
