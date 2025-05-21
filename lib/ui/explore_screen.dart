import 'package:flutter/material.dart';
import 'package:grabto/main.dart';
import 'package:grabto/theme/theme.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> highlights = [
      {
        'image':
        'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde', // profile
        'type': 'add',
        'label': 'Add Highlight',
      },
      {
        'image':
        'https://images.unsplash.com/photo-1551218808-94e220e084d2', // sandwich
        'profile':
        'https://randomuser.me/api/portraits/women/44.jpg', // avatar
        'label': 'Michelle Dam',
      },
      {
        'image':
        'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe', // salad
        'profile':
        'https://randomuser.me/api/portraits/men/32.jpg',
        'label': 'Podmark',
      },
      {
        'image':
        'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe', // salad
        'profile':
        'https://randomuser.me/api/portraits/men/32.jpg',
        'label': 'Podmark',
      },
      {
        'image':
        'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe', // salad
        'profile':
        'https://randomuser.me/api/portraits/men/32.jpg',
        'label': 'Podmark',
      },
      {
        'image':
        'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe', // salad
        'profile':
        'https://randomuser.me/api/portraits/men/32.jpg',
        'label': 'Podmark',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(68),
        child: AppBar(
          backgroundColor: MyColors.whiteBG,
          leadingWidth: widths*0.85,
          leading:Container(
            margin: EdgeInsets.only(left: widths*0.04,top: 10,bottom: 5),
            child: TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 5),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: MyColors.textColorTwo.withAlpha(50))
                ),
                hintText: 'Search for profiles',
                hintStyle: TextStyle(fontSize: 12,color: MyColors.textColorTwo),
                suffixIcon:Icon(Icons.search, color: Colors.grey,size: 18,),
              ),
            ),
          ) ,
          actions: [
            CircleAvatar(
              radius: 14,
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.message_sharp,size: 14,),
            ),
            SizedBox(width: widths*0.05,)
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(left: 16,right: 16),
          children: [
            SizedBox(
              height: heights*0.3,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: highlights.length,
                separatorBuilder: (_, __) => const SizedBox(width: 20),
                itemBuilder: (context, index) {
                  final item = highlights[index];
                  return Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              item['image'],
                              height: heights*0.23,
                              width: widths*0.35,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            bottom: -16,
                            child: item['type'] == 'add'
                                ? Container(
                              height: 36,
                              width: 36,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black,
                                border: Border.all(
                                    color: Colors.white, width: 3),
                              ),
                              child: const Icon(Icons.add,
                                  color: Colors.white, size: 20),
                            )
                                : Container(
                              height: 36,
                              width: 36,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white, width: 3),
                                image: DecorationImage(
                                  image: NetworkImage(item['profile']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        item['label'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Row(
              children:  [
                Row(
                  // mainAxisAlignment:
                  // MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: heights * 0.02,
                      width: 2,
                      color: MyColors.redBG,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Explore Posts',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),

                Spacer(),
                Icon(Icons.grid_view,size: 16,),
              ],
            ),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 14,
                          backgroundImage: NetworkImage('https://i.imgur.com/BoN9kdC.png'),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text('Michelle Dam', style: TextStyle(fontWeight: FontWeight.w400,)),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5,horizontal: 15),
                          decoration: BoxDecoration(
                            color: MyColors.grey.withAlpha(50),
                            borderRadius: BorderRadius.circular(2),
                            // border: Border.all(color: MyColors.grey.withAlpha(100))
                          ),
                          child: Text("Follow",style: TextStyle(fontSize: 10,color: MyColors.textColor,fontWeight: FontWeight.w500),),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.asset(
                        'assets/images/food1.png',
                        height: heights*0.35,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: const [
                        Icon(Icons.local_fire_department_outlined, size: 18),
                        SizedBox(width: 4),
                        Text('10.4k',style: TextStyle(fontSize: 12),),
                        SizedBox(width: 16),
                        Icon(Icons.chat_outlined, size: 18),
                        SizedBox(width: 4),
                        Text('324',style: TextStyle(fontSize: 12),),
                        SizedBox(width: 16),
                        Icon(Icons.location_on_outlined, size: 18),
                        SizedBox(width: 4),
                        Text('16',style: TextStyle(fontSize: 12),),
                        Spacer(),
                        Icon(Icons.bookmark_border,size: 18,),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit...',
                              style: TextStyle(fontSize: 12)
                          ),
                          TextSpan(
                              text: "      Read more", style: TextStyle(color: MyColors.textColorTwo,fontSize: 12)
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("10 mins ago", style: TextStyle(color: MyColors.textColorTwo,fontSize: 10))),
                    const SizedBox(height: 10),
                  ],
                );
              },
            ),
            // _buildPostCard(),
          ],
        ),
      ),
    );
  }


  Widget _buildPostCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        // color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: avatar + name + follow


          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 14,
                          backgroundImage: NetworkImage('https://i.imgur.com/BoN9kdC.png'),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text('Michelle Dam', style: TextStyle(fontWeight: FontWeight.w400,)),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5,horizontal: 15),
                          decoration: BoxDecoration(
                            color: MyColors.grey.withAlpha(50),
                            borderRadius: BorderRadius.circular(2),
                            // border: Border.all(color: MyColors.grey.withAlpha(100))
                          ),
                          child: Text("Follow",style: TextStyle(fontSize: 10,color: MyColors.textColor,fontWeight: FontWeight.w500),),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.asset(
                        'assets/images/food1.png',
                        height: heights*0.35,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: const [
                        Icon(Icons.local_fire_department_outlined, size: 18),
                        SizedBox(width: 4),
                        Text('10.4k',style: TextStyle(fontSize: 12),),
                        SizedBox(width: 16),
                        Icon(Icons.chat_outlined, size: 18),
                        SizedBox(width: 4),
                        Text('324',style: TextStyle(fontSize: 12),),
                        SizedBox(width: 16),
                        Icon(Icons.location_on_outlined, size: 18),
                        SizedBox(width: 4),
                        Text('16',style: TextStyle(fontSize: 12),),
                        Spacer(),
                        Icon(Icons.bookmark_border,size: 18,),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit...',
                              style: TextStyle(fontSize: 12)
                          ),
                          TextSpan(
                              text: "      Read more", style: TextStyle(color: MyColors.textColorTwo,fontSize: 12)
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text("10 mins ago", style: TextStyle(color: MyColors.textColorTwo,fontSize: 10)),
                  ],
                );
              },
            ),
          ),

        ],
      ),
    );
  }
}
