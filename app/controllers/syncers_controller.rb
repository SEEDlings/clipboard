class SyncersController <ApplicationController
  def show

    render json: Syncer.find_by(id: 1).to_json
  end
end