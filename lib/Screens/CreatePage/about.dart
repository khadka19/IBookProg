import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petrolpump/CommonWidgets/colors.dart';

class AboutPage extends StatefulWidget {
  final String title;

  const AboutPage({Key? key, this.title = "Create Order"}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.kPrimaryColor,
        elevation: 0,
        title: Text(widget.title),
        centerTitle: true,
        leading: const DrawerWidget(),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset("assets/images/logo.png"),
              ),
              
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(
                                    0.7), // Adjust the opacity to make it darker
                                BlendMode
                                    .darken, // This blend mode darkens the image
                              ),
                              child: Image.asset(
                                "assets/images/AboutUsImage.jpg",
                                height: 250,
                                width: double.maxFinite,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 60),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "MOST TRUSTED",
                                      style: GoogleFonts.aboreto(
                                          color: Colors.white),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text("DIGITAL IT SOLUTIONS",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20)),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Creating innovative Softwares, Websites & Mobile apps since 2012",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Container(
                      height: 20,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Text(
                            "About Us",
                            textAlign: TextAlign.start,
                            style: GoogleFonts.abrilFatface(
                              letterSpacing: 3,
                              color: AppColors.kPrimaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              decorationThickness: 2,
                            ),
                          ),
                        
                          const Divider(
                           indent: 150,
                           endIndent: 150,
                            color: Colors.orange,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Progressive Technologies has grown into a leading, full service digital agency. With a team of talented developers and designers, we’ve been able to deliver digital solutions for our clients, helping them to succeed in their various industries.“ A customer is the most important visitor on our premises, he is not dependent on us. We are dependent on him. He is not an interruption in our work. He is the purpose of it. He is not an outsider in our business. He is part of it. We are not doing him a favour by serving him. He is doing us a favour by giving us an opportunity to do so.”",
                            softWrap: true,
                            style: GoogleFonts.abyssinicaSil(color: Colors.black87,fontSize: 15),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text("- Mahatma Gandi -",
                              style: GoogleFonts.actor(
                                color: Colors.black,
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 10,
                color: Colors.black,
              ),
              Container(
                decoration: BoxDecoration(
          
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Colors
                          .transparent, // Start with transparent at the top
                      Colors.black.withOpacity(
                          0.8), // Adjust opacity and color as needed
                    ])),
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 30, 10, 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Corporate Office",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.abrilFatface(
                            letterSpacing: 3,
                            color: AppColors.kPrimaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            decorationThickness: 2,
                          ),
                        ),
                        const SizedBox(height: 7.5,),
                       Divider(endIndent: MediaQuery.of(context).size.width*0.8,color: Colors.orange,),
                       const SizedBox(height: 7.5,),
                        Text(
                          "Progressive Technologies Pvt. Ltd.",
                          style: GoogleFonts.aboreto(color: Colors.black87,fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text("Solteemode-13",
                            style: TextStyle(
                                color: Colors.black87, fontSize: 15)),
                        const SizedBox(
                          height: 3,
                        ),
                        const Text(
                          "Kathmandu 44600",
                          style:
                              TextStyle(color: Colors.black87, fontSize: 15),
                        ),
                         const SizedBox(
                          height: 3,
                        ),
                        
                        const Text(
                          "Nepal",
                          style:
                              TextStyle(color: Colors.black87, fontSize: 15),
                        ),
                         const SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Phone: +977-9851132290, 9803771574",
                          style:
                              GoogleFonts.actor(color: Colors.white54, fontSize: 15),
                        ),
                         const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Email: info@progtechno.com",
                          style:
                              GoogleFonts.actor(color: Colors.white54, fontSize: 15),
                        ),
                        const SizedBox(height: 10,)
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        ZoomDrawer.of(context)!.toggle();
      },
      icon: const Icon(Icons.menu),
    );
  }
}
