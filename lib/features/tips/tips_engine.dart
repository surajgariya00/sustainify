class TipsEngine {
  List<String> getForMonthly(double monthlyKg) {
    if (monthlyKg > 200) {
      return [
        'Try public transport twice a week',
        'Improve AC efficiency & LED lights',
      ];
    } else if (monthlyKg > 80) {
      return ['Carpool once a week', 'Add one vegetarian day per week'];
    } else {
      return [
        'Great job! Maintain your habits',
        'Share your tips with friends',
      ];
    }
  }
}
