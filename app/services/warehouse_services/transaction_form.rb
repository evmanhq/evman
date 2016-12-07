module WarehouseServices
  class TransactionForm
    include ActiveModel::Model
    ATTRIBUTES = [:event_id, :description, :count, :returned, :batch_id]

    validates :batch_id, presence: true
    validates :count, numericality: { greater_than: 0 }
    validates :returned, numericality: { greater_than_or_equal_to: 0 }

    validate do |form|
      transaction = form.transaction
      batch = form.batch

      available_count = batch.total - transaction.total
      form.errors.add :base, :not_enough_items_in_batch, count: available_count if available_count < form.count
      form.errors.add :base, :returned_bigger_than_count if form.returned > form.count
      form.errors.add :base, :batch_cannot_be_changed if !transaction.new_record? and transaction.batch_id != form.batch_id
      form.errors.add :base, :event_cannot_be_changed if !transaction.new_record? and transaction.event_id != form.event_id

      form.errors.add :base, :event_id_or_description_required if form.event.blank? and form.description.blank?

      if transaction.new_record? and form.event and form.event.warehouse_transactions.where(batch_id: form.batch_id).any?
        form.errors.add :base, :another_transaction_with_this_batch_exists
      end
    end


    attr_reader :transaction
    attr_reader *ATTRIBUTES
    def initialize transaction, params = nil
      @transaction = transaction
      params ||= {}

      raise ArgumentError, 'transaction is not type of WarehouseTransaction' unless transaction.is_a? WarehouseTransaction

      @event_id    = params[:event_id]    || transaction.event_id
      @description = params[:description] || transaction.description
      @batch_id    = params[:batch_id]    || transaction.batch_id
      @returned    = params[:returned]    || transaction.returned    || 0
      @count       = params[:count]       || -transaction.count      || 0

      attrs_to_integer :event_id, :batch_id, :returned, :count
    end

    def event
      @event ||= Event.where(id: event_id).first
    end

    def batch
      @batch ||= WarehouseBatch.where(id: batch_id).first
    end

    def total
      count - returned
    end

    def submit
      ActiveRecord::Base.transaction do
        batch.lock!
        return false if invalid?
        transaction.event_id = event_id
        transaction.batch_id = batch_id
        transaction.count = - count
        transaction.returned = returned
        transaction.description = description
        transaction.save!
      end
      true
    rescue ActiveRecord::RecordInvalid => e
      e.record.errors.full_messages.each do |message|
        errors.add :base, :message
      end
      false
    end

    def to_model
      transaction
    end

    private

    def attrs_to_integer *attrs
      attrs.each do |attr|
        value = instance_variable_get("@#{attr}")
        instance_variable_set("@#{attr}", value.to_i) if value.present?
      end
    end
  end
end