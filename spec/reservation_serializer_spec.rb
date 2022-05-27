# frozen_string_literal: true
# require 'spec_helper'
require "rails_helper"  # this

describe Api::V1::ReservationSerializer do
  subject { serializer.as_json }
  g = Guest.new(12, 'Cleve', 'Gomes')
  t1 = Table.new(16,16,16)
  t2 = Table.new(11,11,11)
  t = [t1, t2]
  r = Restaurant.new(12, 'Knafeh', 'Al Barsha')
  let(:reservation) { Reservation.new(66, 'not_confirmed', 2, false, '10:30', 5400, nil, g, r, t) }
  let(:serializer) { described_class.new(reservation).serializer[:reservation] }
  it "allows attributes to be defined for serialization" do

    expect(subject.keys).to contain_exactly(
                              *%w[
                                  id
                                  status
                                  covers
                                  walk_in
                                  start_time
                                  duration
                                  notes
                                  created_at
                                  updated_at
                                  restaurant
                                  guest
                                  tables
                              ]
                            )
  end

  describe "relationships" do
    it "returns single restaurant" do
      data = Api::V1::RestaurantSerializer.new(reservation.restaurant).serializer.as_json.deep_stringify_keys
      expect(subject['restaurant']).to eq(data['restaurant'])
    end
    it "returns single guest" do
      data = Api::V1::GuestSerializer.new(reservation.guest).serializer.as_json.deep_stringify_keys
      expect(subject['guest']).to eq(data['guest'])
    end
    it "returns array of tables" do
      data = reservation.tables.map { Api::V1::TableSerializer.new(_1).serializer.as_json['table'] }
      expect([subject['tables']]).to contain_exactly(data)
    end
  end

  describe "notes" do
    it "is nil if an empty string" do
      reservation.notes = ""
      expect(subject['notes']).to eq(nil)
    end
  end

  describe "#as_json" do
    it "returns correct payload" do
      expect(subject.except('guest', 'restaurant', 'tables')).to eq(
      'id' => reservation.id,
      'status' => "not_confirmed",
      'covers' => 2,
      'walk_in' => false,
      'start_time' => reservation.start_time.to_time.iso8601,
      'duration' => 5400,
      'notes' => nil,
      'created_at' => reservation.created_at.to_time.iso8601,
      'updated_at' => reservation.updated_at.to_time.iso8601
      )
    end
  end
end