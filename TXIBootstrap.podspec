
Pod::Spec.new do |s|
  s.name             = "TXIBootstrap"
  s.version          = "0.1.2"
  s.summary          = "Collection of tools used across projects"

  s.description      = <<-DESC
                        Collection of tools used across projects
                      DESC

  s.homepage         = "https://github.com/tablexi"
  s.license          = 'MIT'
  s.author           = { "Ed Lafoy" => "ed@tablexi.com" }
  s.source           = { :git => "git@github.com:tablexi/txi-ios-bootstrap.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/*'
  s.resource_bundles = {
    'TXIBootstrap' => ['Pod/Assets/*.png']
  }

  s.subspec 'LogManager' do |cs|
    cs.source_files = 'Pod/Classes/Managers/LogManager.swift'
    cs.dependency 'TXIBootstrap/UIColorExtensions'
  end

  s.subspec 'EnvironmentManager' do |cs|
    cs.source_files = 'Pod/Classes/Managers/EnvironmentManager.swift'
    cs.dependency 'TXIBootstrap/LogManager'
  end
  s.subspec 'ObserverManager' do |cs|
    cs.source_files = 'Pod/Classes/Managers/ObserverManager.swift'
  end

  s.subspec 'UIColorExtensions' do |cs|
    cs.source_files = 'Pod/Classes/Extensions/UIColorExtensions.swift'
  end

end
