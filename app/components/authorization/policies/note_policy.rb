module Authorization
  module Policies
    class NotePolicy < Base
      alias_method :note, :model
      def read?
        return true unless note.event
        dictator.authorized? note.event, :read
      end

    end
  end
end