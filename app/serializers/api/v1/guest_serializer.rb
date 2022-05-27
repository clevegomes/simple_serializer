class Api::V1::GuestSerializer < Api::V1::SimpleSerializer
  attributes :id,
             :first_name,
             :last_name
end