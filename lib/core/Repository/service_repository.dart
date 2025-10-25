import '../Models/service_model.dart';

class ServiceRepository {
  List<ServiceModel> getAllServices() {
    return [
      ServiceModel(
        id: '1',
        title: 'سباك',
        image: 'assets/images/service1.png',
        color: 0xFF2196F3,
      ),
      ServiceModel(
        id: '2',
        title: 'نجار',
        image: 'assets/images/service2.png',
        color: 0xFF4CAF50,
      ),
      ServiceModel(
        id: '3',
        title: 'حداد',
        image: 'assets/images/service3.png',
        color: 0xFFFF9800,
      ),
      ServiceModel(
        id: '4',
        title: 'فني تكييف',
        image: 'assets/images/service4.png',
        color: 0xFF2196F3,
      ),
      ServiceModel(
        id: '5',
        title: 'مبلط أرضيات وسيراميك',
        image: 'assets/images/service5.png',
        color: 0xFF4CAF50,
      ),
      ServiceModel(
        id: '6',
        title: 'صيانة وتصليح ثلاجات',
        image: 'assets/images/service6.png',
        color: 0xFFFF9800,
      ),
      ServiceModel(
        id: '7',
        title: 'كهربائي',
        image: 'assets/images/service7.png',
        color: 0xFF2196F3,
      ),
      ServiceModel(
        id: '8',
        title: 'مصلح غسالات',
        image: 'assets/images/service8.png',
        color: 0xFF4CAF50,
      ),
      ServiceModel(
        id: '9',
        title: 'تركيب اثاث',
        image: 'assets/images/service9.png',
        color: 0xFFFF9800,
      ),



    ];
  }
}
