class Round {
  double multi;
  List<int> points;
  Round(this.points, this.multi);
  String toString() {
    String s = "";
    for (int i = 0; i < points.length; i++) {
      s += points[i].toString() + " ";
    }
    return s;
  }
}
