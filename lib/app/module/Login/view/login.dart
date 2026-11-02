import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/module/Login/LoginController/loginCnt.dart';
import 'package:get/state_manager.dart';

class Loginview extends GetView<Logincnt> {
  const Loginview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            SizedBox(height: 120),
            Icon(Icons.warehouse, size: 60, color: Colors.purple),
            SizedBox(height: 20),
            Text(
              "Precision Warehouse Management",
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 30),
            TextField(
              controller: controller.emailCnt,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 15),
            Obx(
              () => TextField(
                controller: controller.passwordCnt,
                obscureText: controller.obscuretext.value,
                decoration: InputDecoration(
                  labelText: "Password",
                  suffixIcon: IconButton(
                    onPressed: controller.toggle,
                    icon: Icon(
                      controller.obscuretext.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Forgot Password?",
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ],
            ),
            SizedBox(height: 30),
            Obx(
              () => MaterialButton(
                minWidth: double.infinity,
                height: 65,
                onPressed: () {
                  controller.loginUser();
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.deepPurple.shade600,
                textColor: Colors.white,
                child: Center(
                  child: controller.loading.value
                      ? CircularProgressIndicator()
                      : Text(
                          "Sign In",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text("OR", style: TextStyle(color: Colors.black)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: Text("Dont Have an Account ?")),
                InkWell(
                  onTap: () {},
                  child: Text(
                    " Request Access",
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
