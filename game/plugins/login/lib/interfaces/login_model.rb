module AresMUSH
  class Character
    field :email, :type => String
    field :terms_of_service_acknowledged, :type => DateTime
    field :announce, :type => String, :default => "all"
  end  
end