class Syncer < ActiveRecord::Base
  def syncup
    # ask SFDB if there have been changes since syncer.last_sync
      # if not, do nothing
      # if there have, query for all contacts, all volunteer shifts, and all shift details
      # created or modified since syncer.last_sync
      # as one big Mash (only one query)
      # preferably in an easy-to-parse structure with child relationships preserved
      # and save it as an instance variable
      # and update syncer.last_sync

    # for each contact, vol shift, and shift detail in the variable Mash,
    # call a method on them to check for existing Volunteers and Shifts by sf_id
        # and if they are found, call update methods on them
        # and if they are not, call create methods on them
  end

  def full_sync
    # as above, without conditional(s)(?)
  end
end
