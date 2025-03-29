import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guftagu_mobile/components/fade_network_placeholder_image.dart';
import 'package:guftagu_mobile/components/gradient_text.dart';
import 'package:guftagu_mobile/configs/app_text_style.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:lottie/lottie.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key, required this.startChat});
  final VoidCallback startChat;

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  String selectedCategoryTab = "";

  void selectCategoryTab(String tab) {
    setState(() {
      selectedCategoryTab = tab;
    });
  }

  Widget buildHeader() {
    return Container(
      margin: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.pinkAccent, Colors.amber],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: SizedBox(
        height: 170.h,
        child: Row(
          children: [
            Flexible(
              flex: 45,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Let's create your first character Now!",
                      style: context.appTextStyle.text,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 8.w,
                        horizontal: 20.w,
                      ),
                      decoration: BoxDecoration(
                        color: context.colorExt.background,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        "Create Now",
                        style: context.appTextStyle.textSmall.copyWith(
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 35,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Assets.images.imgTrans2.image(
                      fit: BoxFit.contain,
                      height: 150.h,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Assets.images.imgTrans1.image(
                      fit: BoxFit.contain,
                      height: 150.h,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGradientTexts() {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GradientText(
            "Explore",
            gradient: LinearGradient(
              colors: [context.colorExt.tertiary, context.colorExt.primary],
              begin: Alignment(-0.5, -1.5),
              end: Alignment(1.3, 1.5),
            ),
            style: context.appTextStyle.subTitle,
          ),
          Text(" AI Characters", style: context.appTextStyle.subTitle),
        ],
      ),
    );
  }

  Widget buildCategoryTabs() {
    final categories = [
      "Lover",
      "Sports",
      "Girlfriend",
      "Bollywood",
      "Fashion",
      "Villain",
      "Comedian",
      "Anime",
      "Gamer",
      "Celebrity",
      "Sci-Fi",
      "Horror",
      "Superhero",
      "Historical",
    ];

    return SizedBox(
      height: 36.h,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          bool isSelected = category == selectedCategoryTab;

          return Padding(
            padding: EdgeInsets.only(
              right: index < categories.length - 1 ? 8.0.w : 0,
            ),
            child: GestureDetector(
              onTap: () => selectCategoryTab(category),
              child: Container(
                height: 36.h,
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.h),
                decoration: BoxDecoration(
                  color: isSelected ? Color(0xFFB1B0BD) : Color(0xFF23222F),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  category,
                  style: AppTextStyle(context).textSemibold.copyWith(
                    color:
                        isSelected
                            ? context.colorExt.background
                            : context.colorExt.textPrimary.withValues(
                              alpha: 0.6,
                            ),
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildCharacterGrid() {
    final imageUrls = [
      // Assets.images.img1,
      // Assets.images.img2,
      // Assets.images.img3,
      // Assets.images.img4,
      // Assets.images.img1,
      // Assets.images.img2,
      // Assets.images.img3,
      // Assets.images.img4,
      "https://s3-alpha-sig.figma.com/img/8f9d/4794/e0988770a87265c7ab986bd744e9f04d?Expires=1743984000&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=CZ5giiDo1~9jlcwwm56-4DgUeiU4kO3~fwxO7Q8koGLCHlNZ6ZkSCkW67tcVSxDYGPUkoi2sDZDVbMgVw1vjVa3DLLGyzk1~qgGyC4jYwF9qeRsEMPxeZwHzAj6FkCQaHSBGTkkn1CaKO92OVqkg3FeST1~is~YPQH-hLddKE3MDlgFNONYnOS5xITiM4src6sES6ZcGZeCcVewvIuo9Q6J7qh7Ip7TzuHXucQrPwyqcfUI-Q~KOtuTG8McwUnZRXoIZ8pcxuluKXtzjcefiN2O7nBwsBcC5l4ofUtQK3eGvV92COwzg0TsCoCQRyLOcvHKAlnYwbpqI1~ujAcnpOw__",
      "https://s3-alpha-sig.figma.com/img/6e57/e57b/f29c118f7be22a776ec964a0e4bd3fde?Expires=1743984000&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=DIYAHx-oB6hukcjxkhyGmGpccO4hLzyIpn~jTI7vu0DZFTMckj9odkttmBB2vsNRpmEJDBbb6jxKYMerwupqOJJFoBUlm9D1oyNQct0TQ2BUQmGsDTrDGEYvpSlrv3P6GVHUKZxd6m3qmaZvXENeDsEFTQMAdjFq7ubektmdjaSjGA8Rd7MDX2T-cM7Xe3PG5U1UOLpRpAJwLHuy4BK5iUT0xoEE6y-mUW-V9nUyPN1ydYLm~vHeAZAgDiZgWVIiPUcAFX9uQVZECYLO4bvp6g93ozD2cHbE5N~aoHRkA8yT4ajGM-BeMxjtorpvs8ChhXRcbMWMsWfoP09vAgW4xA__",
      "https://s3-alpha-sig.figma.com/img/b620/0965/43db6d263ffece16299f292a03269267?Expires=1743984000&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=k2-5TIgVRG5AfMdQh0p1cokfdIY5F6Ra6EiYFJE8v-BERSAEdYRD86siC41r2EoMRc30BKTCdCkdawfwpc3YKyLe-oUryTIjnoob5ZIm~-f2jn81nylf6pfAWlF5B2dz~nAzZxcV9U2p8zNNLOlaAesoOv5mpHjGl~qzJOFaXIu5~5r4MfQnI~XkVhudMIf2N4BqyzsesLMXJjhicqinrA9PpSuhJUNqR91rL1y2bA8Qb4vvczaS~4WQ232BqWT21ecid8fuozCA387bfDW9NsyFA6McjSmUUR18P7xrWlNiSQrl3IZH8N3UpWwu~yJTPyuNNVF6AGBcxbmYZG66wQ__",
      "https://s3-alpha-sig.figma.com/img/fd5b/9143/f5124375a8c5b85ae376cd534d2e51a1?Expires=1743984000&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=oMkQZyP-Lcwoo9S1l1ETcuwHGtrYGlgZn1KAlD7ZYfZhJmGZKfeEcuQp5OYMIgrf58Pyb0kIIIB-9K2rY153kwmtcAsDiMLVIgk3SAxwrbQLBNgmx2pgqBQcHB-8gfEJBCqveUUlJmo7BOufvTSUIpPecvRuE9pbuogibYR1FE8SFbL9AcljAlUR4ymFusYDnEhzrzxFTgRPNOBVrXKlcx6mpKCKqayaMXIJUMvjmRR5mSrgd3L-BNe4TELDgHc2M2ndIZC9CTa55WS1hBeX8MPrSE7kFGKgqYtuWQsXSpZ3z4-DpAD4CB7750aK9zE-MYhMvN1Vv2FtB3JHKKeCaQ__",
      "https://s3-alpha-sig.figma.com/img/ec4e/1546/3df3272223ea091aefbdf9efcfbcfe2f?Expires=1743984000&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=lzGqiETkMkueKsmybTE~CVcnip9gQ6Lnvmhg14HNYxFfb2at-8BmGD1QJhkE7jJrwmTkeaIa-gzBQYYJIWdbbKHB3j6PXMi4zeh05m9z-baL73tmh4XtTi8dkvj0e3jgWGgZcZ0lQvh39dXwj1wkavJcU4d69IPie6-eA~BnVSWD3KH47hH1cW-tczakeCKzIfCsrQNEO-~8Zzg6dKjXQpGsDR3E4Rmu9VwOo4uJl~wBBxzwPNShOAjyK8ZAFBZovGpYxw-QMee-92Tn0eXMXXNcwkOUtk87ciYPRTjMsj5z9~oWO44nyutOiGtA1KMkp8yyKmlVuuytEHbPod45Sw__",
      "https://s3-alpha-sig.figma.com/img/c162/4e5f/77b763533de28f23ccb09ac5a20358cd?Expires=1743984000&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=XFFNX1QAyQ6Y9VVOFrV1Nv52mgIw9frE7zAyebmQ0eve2K2hWX4AdtLySaxnFKhnXuRlBQzbLzIiBKSCKUZyqttJtjn6Z21qMR2HgULwgqUZfHZw76ZJgnXbRCJuN06mONSM0Aj9ztIzG1ZfRBerWudRKppY5dNktnNZmdECa6dYaYNJTk0AHp40mGE33x-gnC5yu-sPfRraVq4KhpJI9xseM7HcSrwPKivZVhTWoyvpe-qy1C2k8yk~l1bjS4V-SXR2EFV9huDydIxIGi-bzD29s8mtilefuPWfyYX7HJqqh-5WGU8VTzi-HhguoOrfnh5NhRNaBaMLNOZ4y-f1Cw__",
      "https://s3-alpha-sig.figma.com/img/04a6/9b5d/fa7f0a37c614d92068c08b60fadfc31b?Expires=1743984000&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=Gbi1ENdRns3FWQTjTwnbsdiBDhzBY77frZSdwmgE-y8XnhOsixzV~4AfvY6CLNgENdoOahcDDRufl~qGX6gPv8TVVJPUEj0NmzppSUiF38E9ektDipjKBsMKVOdD-V9rXN0-bkjzObPIZb5Y1lUudmlhaBy1~huwTli8cgztDIxIe53XhdrFGjdmMjTjdlPtBCwNXnmB9AeMfADKKNQEala3Hjcue0mN6QEOLJXabRPndhD3RIF5q82xHe7g9PCuvkaQRW5UR3qeKWEB8Eq9ptr-qwUWk6y78tmOci-VeXX8Elq1RxHOCne39ipNJBe-MMiKY53jnXIVZxEhjRgp~A__",
      "https://s3-alpha-sig.figma.com/img/4ae0/0daf/264af2e445070a76bbaa959ce420bc35?Expires=1743984000&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=En1m6G0wC984-Cf5-CtA7rUmWcdAG3vCYv5ynq2quyCF06vTmbfbYEAQkITAnGQKUOM9xbN90lV-Bzh2aQxA5tNbbvotK91PELqJZvBu-svgpWNQba~G9MMT4JNA0C9ZoX7ZuiHlTbxbMWC~u53nNoApEVic9sTfNFRJ-wz4JIu3z6XUe28MBR3rRcSHGHoEBaJGgAtziXl-rwdbsyq219xaG5U3~-cxSEOzaVvYpsRc4lJigWVGMUA0QKAFqNoSzEHtpUd8Uc3iKGLBsYw9usiWAJHRsG6UwunB8addpX~oKu2nNCbdeInyY0y1aGXRoowbvq4XXUymUsw~jYBgtQ__",
      "https://s3-alpha-sig.figma.com/img/441e/aa9f/f8aeb63d8538759622874aab6682170d?Expires=1743984000&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=ViE97PPsX2l0KooyYm-6l4MuO3iaK-zHNrTMWueS6bn3Fiocc8awwl3KjQAv7U-dleRyrWi9PKQuND~7fUaYyLPqA1HY-DLApIUfmzHa14Sytv2jaQzUMwhrCE5zqqRDVJIxqziIBr13XkRCf6pIRsJWTxL0~~rhhIOg9JYm5LP~hedqREuTqx3p5zgjQ5wM2J0meUPBbcgI0oiIjlg4SNDvowp91AHYqPn4ZjwlILYJGAuwnV-zFXkLqOwCT1QzIGcWGM3Rr7-BypF4exfI9S4dJ1CWVZ7vgnx5dQEkMIzh6ac9X6-rlNun-V~SKlA8wCvmNGjat70ZYAJfe0QxKA__",
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.w,
          childAspectRatio: 0.9,
        ),
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                NetworkImageWithPlaceholder(
                  imageUrl: imageUrls[index],
                  placeholder: Center(
                    child: SizedBox(
                      width: 60.w,
                      height: 60.w,
                      child: Lottie.asset(
                        Assets.images.logoAnimation,
                        fit: BoxFit.contain,
                        width: 5.w,
                        height: 5.w,
                      ),
                    ),
                  ),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: IconButton(
                      icon: SvgPicture.asset(Assets.svgs.icChat),
                      onPressed: widget.startChat,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeader(),
          buildGradientTexts(),
          buildCategoryTabs(),
          buildCharacterGrid(),
        ],
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String title;

  const CategoryItem({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Center(
        child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
