
class Specializations {
  Specializations._();

  static const List<String> all = [
    'طوبرجي',
    'موسرجي',
    'كهربائي',
    'نجّار',
    'حدّاد',
    'بلّيط',
    'دهّان',
    'قصّير',
    'جبصين وديكور',
    'رخام وجرانيت',
    'حجر وواجهات',
    'ألمنيوم',
    'زجاج',
    'تسقيف (قرميد/ألواح معدنية)',
    'عزل مائي/حراري',
    'تكييف وتبريد',
    'طاقة شمسية منزلية',
    'سياج وبوابات',
    'فني أجهزة منزلية',
    'كاميرات وأنظمة منزلية ذكية/شبكات',
    'أخرى',
  ];

  
  static String toId(String specialization) {
    return all.indexOf(specialization).toString();
  }

  
  static String fromId(String id) {
    final index = int.tryParse(id) ?? 0;
    return index < all.length ? all[index] : all[0];
  }
}
