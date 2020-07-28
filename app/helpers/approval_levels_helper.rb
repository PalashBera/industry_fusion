module ApprovalLevelsHelper
  def approval_level_type
    controller_name.split("_")[0]
  end
end
