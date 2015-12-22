namespace :codes do
  desc 'Create Japanese name classes from Wikipedia ISO 3166-1 tables.'
  task :update_jp do
    dirname = File.dirname(__FILE__)
    gen     = File.join(dirname, %w{japanese.rb})
    lib     = File.expand_path(File.join(dirname, %w{.. lib iso_country_codes japanese.rb}))
    require gen
    modules = IsoCountryCodes::Task::UpdateJapaneseName.get
    File.open(lib, File::CREAT | File::TRUNC | File::WRONLY) do |f|
      f.write modules
    end
  end
end # :currency
