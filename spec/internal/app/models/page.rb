class Page < ActiveRecord::Base
  localizable do
    attribute :name
    attribute :body
  end
end
