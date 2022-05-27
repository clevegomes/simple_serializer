class Api::V1::RestaurantSerializer < Api::V1::SimpleSerializer
  attributes :id,
             :name,
             :address

  def address
    object.address.presence
  end
end