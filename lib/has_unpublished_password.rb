require 'digest/sha1'

if defined? ::ActiveModel
  require 'has_unpublished_password/never_leaked_to_hibp_validator'
end

require "has_unpublished_password/version"
require 'has_unpublished_password/sha_bloom'

module HasUnpublishedPassword

  class << self
    attr_writer :filter
    def filter
      @filter ||= HasUnpublishedPassword::ShaBloom::DefaultConfig.deserialize(
        File.join(File.dirname(__FILE__), '..', 'serialized-top-11200000')
      )
    end

    def has_been_published?(password)
      filter.check_value(password)
    end
  end

end

__END__

u = User.last
u.password = "password"
u.valid?
u.errors[:password]
