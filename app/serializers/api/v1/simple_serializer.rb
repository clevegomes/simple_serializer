class Api::V1::SimpleSerializer
  class << self

    # initialize variables when class in inherited
    def inherited(base)
      base._attributes = (_attributes || []).dup
      base._associations = (_associations || {}).dup
      base._iso_timestamp_columns = (_iso_timestamp_columns || []).dup
    end

    # static variables
    attr_accessor  :_attributes, :_associations, :_iso_timestamp_columns

    # static method for associations
    def belongs_to(*attrs)
      associate(*attrs)
    end

    # static method for associations
    def has_one(*attrs)
      associate(*attrs)
    end

    # static method for associations
    def has_many(*attrs)
      associate(*attrs)
    end

    # static method keep list of iso timestamp variables
    def iso_timestamp_columns (*attrs)
      @_iso_timestamp_columns << attrs
    end

    # creating getters for variables
    def attributes(*attrs)

      attrs.each do |attr|
        striped_attr = strip_attribute attr
        # binding.pry
        @_attributes << striped_attr

        define_method striped_attr do
          object.send(attr)
        end unless method_defined?(attr)
      end

    end


    private

    # strip clean variable names
    def strip_attribute(attr)
      symbolized = attr.is_a?(Symbol)

      attr = attr.to_s.gsub(/\?\Z/, '')
      attr = attr.to_sym if symbolized
      attr
    end

    # method for the associations, belongs_to, has_one, has_many
    def associate(*attrs)
      associate_serializer = attrs.extract_options!

      attrs.each do |attr|
        define_method attr do
          object.send attr
        end unless method_defined?(attr)
        @_associations[attr] = associate_serializer

      end
    end
  end

  # object variables
  attr_accessor :object, :plural_default_root

  # constructor
  def initialize(object, options={})
    @object        = object
    @plural_default_root = options[:is_plural] || false
  end

  # method to retrieve the object variables
  def attributes
    time_stamp_col = []
    if self.class._iso_timestamp_columns.count > 0
      time_stamp_col = self.class._iso_timestamp_columns.flatten
    end
    self.class._attributes.dup.each_with_object({}) do |name, hash|
      if time_stamp_col.include?(name)

        hash[name] = send(name).to_time.iso8601
      else
        hash[name] = send(name)
      end
    end
  end

  # method to retrieve the object association variables
  def associations
    associations = self.class._associations
    included_associations = associations.keys
    # binding.pry
    hash = {}
    associations.each_with_object({}) do |(name, association)|

      if object[name].is_a? Array
        object[name].each do |sel_obj|
          # binding.pry
          a = association[:serializer].new sel_obj, {:is_plural => true}
          hash[name] = hash[name].push(a.serializer[name]).compact.flatten if hash[name].is_a? Array
          hash[name] = a.serializer[name] unless hash[name].is_a? Array
        end
      else
        a = association[:serializer].new object[name]
        hash = hash.deep_merge(a.serializer)
      end
    end
    hash
  end

  # method to retrieve the root variable name . Singular or Plural
  def json_key
      root_name = self.object.class.to_s.demodulize.underscore.sub(/_serializer$/, '')
      self.plural_default_root ? root_name.pluralize : root_name
  end

  # method to serializer the object
  def serializer
    hash = {}
    hash[json_key.to_sym] = self.plural_default_root ? [attributes.merge(associations)] : attributes.merge(associations)
    hash
  end



end