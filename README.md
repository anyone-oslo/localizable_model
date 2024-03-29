[![Version](https://img.shields.io/gem/v/localizable_model.svg?style=flat)](https://rubygems.org/gems/localizable_model)
[![Build](https://github.com/anyone-oslo/localizable_model/actions/workflows/build.yml/badge.svg)](https://github.com/anyone-oslo/localizable_model/actions/workflows/build.yml)
[![Code Climate](https://codeclimate.com/github/anyone-oslo/localizable_model/badges/gpa.svg)](https://codeclimate.com/github/anyone-oslo/localizable_model)
[![Test Coverage](https://codeclimate.com/github/anyone-oslo/localizable_model/badges/coverage.svg)](https://codeclimate.com/github/anyone-oslo/localizable_model)
[![Inline docs](http://inch-ci.org/github/anyone-oslo/localizable_model.svg)](http://inch-ci.org/github/anyone-oslo/localizable_model)
[![Security](https://hakiri.io/github/anyone-oslo/localizable_model/master.svg)](https://hakiri.io/github/anyone-oslo/localizable_model/master)

# LocalizableModel

LocalizableModel allows any ActiveRecord model to have localized attributes.

## Installation

Add the `localizable_model` gem to your Gemfile:

``` ruby
gem "localizable_model"
```

Generate the migration:

``` shell
bin/rails g localizable_model:migration
```

## Usage

You can now define localizable attributes on your model:

``` ruby
class Page < ActiveRecord::Base
  localizable do
    attribute :name
    attribute :body
  end
end
```

You can also use a dictionary. This will let you define attributes dynamically
at runtime.

``` ruby
class Page < ActiveRecord::Base
  localizable do
    dictionary lambda { Page.localizable_attrs }
  end

  class << self
    def localizable_attrs
      [:foo, :bar, :baz]
    end
  end
end
```

Usage examples:

``` ruby
page = Page.create(locale: "en", name: "Hello")
page.name? # => true
page.name.to_s # => "Hello"
```

To get a localized version of a page, call `.localize` on it:

``` ruby
page = Page.first.localize("en")
```

`.localize` can also take a block argument:

``` ruby
page.localize("nb") do |p|
  p.locale # => "nb"
end
p.locale # => "en"
```

Multiple locales can be updated at the same time:

``` ruby
page.name = { en: "Hello", fr: "Bonjour" }
```

By chaining through `.any_locale`, you can get results from other locales if
a localization is missing.

``` ruby
page = Page.create(locale: "fr", name: "Bonjour").localize("en")
page.any_locale.name? # => true
page.any_locale.name  # => "Bonjour"
```

## License

LocalizableModel is licensed under the
[MIT License](http://www.opensource.org/licenses/MIT).
