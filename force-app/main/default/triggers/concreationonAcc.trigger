trigger concreationonAcc on Account (after insert) {
  If(trigger.isinsert && trigger.isafter)
  {
      accconcreatehandler.createcon(Trigger.new);
  }
}