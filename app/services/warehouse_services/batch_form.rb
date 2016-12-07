module WarehouseServices
  class BatchForm
    include ActiveModel::Model

    def model_name
      ActiveModel::Name.new(self, nil, "BatchForm")
    end

    validates :count, presence: true, numericality: { greather_than: 0 }

    delegate :persisted?, to: :batch

    attr_reader :batch, :params
    attr_reader :item_id, :count, :price
    def initialize batch, params = {}
      @batch, @params = batch, params
      raise ArgumentError, 'batch is not type of WarehouseBatch' unless batch.is_a? WarehouseBatch

      @item_id = params[:item_id] || batch.item_id
      @count = params[:count] || batch.initial_transaction.try(:count)
      @price = params[:price] || batch.price
    end

    def item
      batch.item || WarehouseItem.where(id: item_id).first
    end

    def submit
      return false if invalid?
      WarehouseBatch.transaction do
        new_record = batch.new_record?
        batch.price = price
        batch.item_id = item_id if new_record
        batch.save!

        if new_record
          transaction = batch.transactions.build count: count
          transaction.save!
        end
      end
      true
    rescue ActiveRecord::RecordInvalid => e
      e.record.errors.full_messages.each do |message|
        errors.add :base, message
      end
      false
    end

    def to_model
      batch
    end
  end
end