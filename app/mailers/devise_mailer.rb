class DeviseMailer < Devise::Mailer
  default from: "from@example.com"
  layout "mailer"
end
