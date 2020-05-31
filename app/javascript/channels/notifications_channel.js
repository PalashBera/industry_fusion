import consumer from "./consumer"

consumer.subscriptions.create("NotificationsChannel", {
  connected() {
    console.log("hi");
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    console.log(data);
    var total_msg = data.length
    $('.msg-body:not(.message-body-' + data.not_notifiable + ')').prepend(data.html);
    $('.msg-tab:not(.message-tab-' + data.not_notifiable + ')').text('Msg(' + total_msg + ')');
    $('.msg-count:not(.message-count-' + data.not_notifiable + ')').text(total_msg)
  }
});
