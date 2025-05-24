import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Imóveis',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                    color: Colors.black,
                  ),
                ),
              ),
              // Carrossel de imóveis com fotos
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  'Com Fotos',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: 200, // Altura do carrossel
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5, // Quantidade de itens no carrossel
                  itemBuilder: (context, index) {
                    return _buildImovelCard(
                      imageUrl: 'https://i.ibb.co/0M67YhR/american-elections-vote-right.jpg',
                      title: 'Casa ${index + 1}',
                      address: 'Rua Exemplo, ${index + 10}, SP',
                      price: '\$${500 + index * 50}',
                      status: 'Completed',
                      statusColor: Colors.green,
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              // Carrossel de imóveis sem fotos
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  'Sem Fotos',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: 200, // Altura do carrossel
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5, // Quantidade de itens no carrossel
                  itemBuilder: (context, index) {
                    return _buildImovelCard(
                      imageUrl: 'https://i.ibb.co/7KmsLmR/cinza.jpg',
                      title: 'Casa ${index + 6}',
                      address: 'Rua Outro, ${index + 20}, SP',
                      price: '\$${400 + index * 40}',
                      status: 'Running',
                      statusColor: Colors.red,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImovelCard({
    required String imageUrl,
    required String title,
    required String address,
    required String price,
    required String status,
    required Color statusColor,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            width: 190,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            width: 190,
            decoration: BoxDecoration(
              color: Color(0xFFFBFBFB),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
            ),
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                Text(
                  address,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFD9D9D9),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.blue,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
