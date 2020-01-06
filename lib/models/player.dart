class Player {
  int id;
  String name;
  int wins;
  int score;
  Player(this.name, this.id) {
    wins = 0;
  }
  clear() {
    wins = 0;
    score = 0;
  }
}
