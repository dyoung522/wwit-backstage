# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'minitest' do
  #interactor :off

  # with Minitest::Test
  watch(%r|^test/.*\/?.*_test\.rb|)
  watch(%r|^lib/(.*)([^/]+)\.rb|)      { |m| "test/#{m[1]}#{m[2]}_test.rb" }
  watch(%r|^test/.*test_helper\.rb|)   { "test" }

  # Rails 4.0
  watch(%r|^app/controllers/api/v\d+/(.*)\.rb|) { |m| "test/controllers/#{m[1]}_test.rb" }
  watch(%r|^app/controllers/(.*)\.rb|) { |m| "test/controllers/#{m[1]}_test.rb" }
  watch(%r|^app/helpers/(.*)\.rb|)     { |m| "test/helpers/#{m[1]}_test.rb" }
  watch(%r|^app/models/(.*)\.rb|)      { |m| "test/models/#{m[1]}_test.rb" }

  # FactoryGirl
  watch(%r|^test/factories/(.*).rb|)   { "test" }
end
