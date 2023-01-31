class ChangeSlotEvent {
  final int oldSlot;
  final int newSlot;

  ChangeSlotEvent(this.oldSlot, this.newSlot);

  @override
  String toString() {
    return "Slot[$oldSlot] -> Slot[$newSlot]";
  }
}
