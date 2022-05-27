class Api::V1::TableSerializer < Api::V1::SimpleSerializer
  attributes :id,
             :number,
             :max_covers
end