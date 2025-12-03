import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  bool _isLoading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    // GET dynamic URL **here**
    final base = AuthService.baseUrl;

    if (base == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal menemukan server Laravel di LAN")),
      );
      return;
    }

    final apiUrl = "$base/login";

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": _emailController.text,
          "password": _passwordController.text,
        }),
      );

      setState(() => _isLoading = false);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final token = data["token"];
        final user = data["user"];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", token);
        await prefs.setString("email", user["email"]);
        await prefs.setInt("user_id", user["id"]);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Login berhasil!")));

        context.go('/beranda', extra: user["email"]);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email atau password salah")),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  //if (_emailController.text == 'admin1@mail.com' &&
  //       _passwordController.text == 'passwrod') {
  //     context.go('/dashboard/kegiatan', extra: loggedInUserEmail);
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Email atau Password salah')),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 255, 235, 188), // hijau pastel terang
              Color.fromARGB(255, 181, 255, 183), // putih kehijauan
            ],
          ),
        ),
        //     body: Stack(
        // children: [
        //   // Background putih
        //   Container(color: Colors.white),

        //   // GORESAN KANAN ATAS
        //   Positioned(
        //     top: -60,
        //     right: -40,
        //     child: Container(
        //       width: 250,
        //       height: 250,
        //       decoration: const BoxDecoration(
        //         shape: BoxShape.circle,
        //         gradient: RadialGradient(
        //           colors: [
        //             Color(0xFFE8F3EB), // hijau lembut
        //             Colors.transparent,
        //           ],
        //           radius: 0.9,
        //         ),
        //       ),
        //     ),
        //   ),

        //   // GORESAN KIRI BAWAH (AGAK TENGAH)
        //   Positioned(
        //     bottom: -40,
        //     left: -30,
        //     child: Container(
        //       width: 280,
        //       height: 280,
        //       decoration: const BoxDecoration(
        //         shape: BoxShape.circle,
        //         gradient: RadialGradient(
        //           colors: [
        //             Color(0xFFDFF0E6), // hijau sedikit lebih tipis
        //             Colors.transparent,
        //           ],
        //           radius: 1.0,
        //         ),
        //       ),
        //     ),
        //   ),

        // backgroundColor: Colors.white,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 380, // ukuran HP
                    minHeight: constraints.maxHeight, // biar penuh layar
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(20),

                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),

                          // LOGO
                          Center(
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/images/logo_jawara.png",
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.contain,
                                ),

                                const SizedBox(height: 4),
                                const Text(
                                  "S I S T E M",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2E7D32),
                                    letterSpacing: 6,
                                  ),
                                ),
                                // const Text(
                                //   "S I S T E M",
                                //   style: TextStyle(
                                //     fontSize: 12,
                                //     fontWeight: FontWeight.w600,
                                //     color: Color(0xFF143621),
                                //     letterSpacing: 6,
                                //   ),
                                // ),
                                const SizedBox(height: 2),
                                const Text(
                                  "JAWARA",
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2E7D32),
                                    letterSpacing: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // EMAIL LABEL
                          // const Text(
                          //   "Email",
                          //   style: TextStyle(fontSize: 13, color: Colors.black87),
                          // ),
                          // const SizedBox(height: 6),

                          // -- MODEL FILL --
                          // TextFormField(
                          //   controller: _emailController,
                          //   style: const TextStyle(color: Colors.white),
                          //   decoration: InputDecoration(
                          //     labelText: "Email",
                          //     labelStyle: const TextStyle(color: Colors.white70),
                          //     filled: true,
                          //     fillColor: const Color(0xFF143621),

                          //     prefixIcon: const Icon(
                          //       Icons.email_outlined,
                          //       color: Colors.white,
                          //     ),

                          //     // BORDER NORMAL
                          //     enabledBorder: OutlineInputBorder(
                          //       borderRadius: BorderRadius.circular(8),
                          //       borderSide: const BorderSide(
                          //         color: Colors.white70,
                          //       ),
                          //     ),

                          //     // BORDER SAAT FOKUS
                          //     focusedBorder: OutlineInputBorder(
                          //       borderRadius: BorderRadius.circular(8),
                          //       borderSide: const BorderSide(
                          //         color: Colors.white, // warna saat fokus
                          //         width: 1.8,
                          //       ),
                          //     ),

                          //     // BORDER SAAT ERROR
                          //     errorBorder: OutlineInputBorder(
                          //       borderRadius: BorderRadius.circular(8),
                          //       borderSide: const BorderSide(color: Colors.red),
                          //     ),

                          //     // BORDER SAAT FOKUS & ERROR
                          //     focusedErrorBorder: OutlineInputBorder(
                          //       borderRadius: BorderRadius.circular(8),
                          //       borderSide: const BorderSide(
                          //         color: Colors.red,
                          //         width: 1.8,
                          //       ),
                          //     ),
                          //   ),

                          //   validator: (value) {
                          //     if (value == null || value.isEmpty) {
                          //       return 'Email tidak boleh kosong';
                          //     }
                          //     if (!value.contains('@')) {
                          //       return 'Masukkan alamat email yang valid';
                          //     }
                          //     return null;
                          //   },
                          // ),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: "Email",
                              labelStyle: const TextStyle(
                                color: Colors.black87,
                              ),

                              filled: true,
                              fillColor: Colors.white, // background putih

                              prefixIcon: const Icon(
                                Icons.email_outlined,
                                color: Color(0xFF2E7D32),
                              ),

                              // BORDER NORMAL (putih + outline hijau)
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFF2E7D32),
                                  width: 1.2,
                                ),
                              ),

                              // BORDER SAAT FOKUS
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(
                                    0xFF0F2A19,
                                  ), // warna hijau lebih gelap saat fokus
                                  width: 1.8,
                                ),
                              ),

                              // BORDER SAAT ERROR
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.red),
                              ),

                              // BORDER ERROR SAAT FOKUS
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 1.8,
                                ),
                              ),
                            ),

                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email tidak boleh kosong';
                              }
                              if (!value.contains('@')) {
                                return 'Masukkan alamat email yang valid';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          // PASSWORD LABEL
                          // const Text(
                          //   "Password",
                          //   style: TextStyle(fontSize: 13, color: Colors.black87),
                          // ),
                          // const SizedBox(height: 6),

                          // PASSWORD BOX
                          // Container(
                          //   decoration: BoxDecoration(
                          //     color: Color(0xFF143621),
                          //     borderRadius: BorderRadius.circular(8),
                          //   ),
                          //   child: TextFormField(
                          //     controller: _passwordController,
                          //     style: const TextStyle(color: Colors.white),
                          //     obscureText: !_isPasswordVisible,
                          //     decoration: InputDecoration(
                          //       border: InputBorder.none,
                          //       prefixIcon: const Icon(
                          //         Icons.lock_outlined,
                          //         color: Colors.white,
                          //       ),
                          //       hintText: "Masukkan Password",
                          //       hintStyle: const TextStyle(color: Colors.white70),
                          //       contentPadding: const EdgeInsets.symmetric(
                          //         vertical: 16,
                          //       ),
                          //       suffixIcon: IconButton(
                          //         icon: Icon(
                          //           _isPasswordVisible
                          //               ? Icons.visibility_outlined
                          //               : Icons.visibility_off_outlined,
                          //           color: Colors.white,
                          //         ),
                          //         onPressed: () {
                          //           setState(() {
                          //             _isPasswordVisible = !_isPasswordVisible;
                          //           });
                          //         },
                          //       ),
                          //     ),
                          //     validator: (value) {
                          //       if (value == null || value.isEmpty) {
                          //         return 'Password tidak boleh kosong';
                          //       }
                          //       if (value.length < 6) {
                          //         return 'Password harus terdiri dari minimal 6 karakter';
                          //       }
                          //       return null;
                          //     },
                          //     // validator: (v) => v!.isEmpty
                          //     //     ? "Password tidak boleh kosong"
                          //     //     : null,
                          //   ),
                          // ),
                          // PASSWORD BOX
                          // TextFormField(
                          //   controller: _passwordController,
                          //   style: const TextStyle(color: Colors.white),
                          //   obscureText: !_isPasswordVisible,
                          //   decoration: InputDecoration(
                          //     filled: true,
                          //     fillColor: const Color(0xFF143621),
                          //     prefixIcon: const Icon(
                          //       Icons.lock_outlined,
                          //       color: Colors.white,
                          //     ),
                          //     hintText: "Masukkan Password",
                          //     hintStyle: const TextStyle(color: Colors.white70),
                          //     contentPadding: const EdgeInsets.symmetric(
                          //       vertical: 16,
                          //     ),
                          //     border: OutlineInputBorder(
                          //       borderRadius: BorderRadius.circular(8),
                          //       borderSide: BorderSide.none,
                          //     ),
                          //   ),
                          //   validator: (value) {
                          //     if (value == null || value.isEmpty) {
                          //       return 'Password tidak boleh kosong';
                          //     }
                          //     if (value.length < 6) {
                          //       return 'Password harus terdiri dari minimal 6 karakter';
                          //     }
                          //     return null;
                          //   },
                          // ),

                          // FILL
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,

                            decoration: InputDecoration(
                              labelText: "Password",
                              labelStyle: const TextStyle(
                                color: Colors.black87,
                              ),

                              filled: true,
                              fillColor: Colors.white, // background putih

                              prefixIcon: const Icon(
                                Icons.lock_outlined,
                                color: Color(0xFF2E7D32),
                              ),

                              // ICON SHOW/HIDE
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: const Color(0xFF2E7D32),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),

                              // BORDER NORMAL
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFF2E7D32),
                                  width: 1.2,
                                ),
                              ),

                              // BORDER SAAT FOKUS
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(
                                    0xFF0F2A19,
                                  ), // hijau lebih gelap saat fokus
                                  width: 1.8,
                                ),
                              ),

                              // BORDER ERROR
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.red),
                              ),

                              // BORDER ERROR SAAT FOKUS
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 1.8,
                                ),
                              ),
                            ),

                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password tidak boleh kosong';
                              }
                              if (value.length < 6) {
                                return 'Password harus terdiri dari minimal 6 karakter';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 5),

                          // REMEMBER + FORGOT
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Row(
                          //       children: [
                          //         Checkbox(
                          //           value: _rememberMe,
                          //           onChanged: (v) {
                          //             setState(() => _rememberMe = v ?? false);
                          //           },
                          //         ),
                          //         const Text("Simpan Kata Sandi"),
                          //       ],
                          //     ),
                          //     GestureDetector(
                          //       child: const Text(
                          //         "Lupa Password?",
                          //         style: TextStyle(
                          //           fontSize: 12,
                          //           fontWeight: FontWeight.w600,
                          //           color: Color(0xFF143621),
                          //           // color: Colors.amber,
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                // TODO: arahkan ke halaman lupa password
                              },
                              child: const Text(
                                "Lupa Password?",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2E7D32),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // LOGIN BUTTON
                          SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _login,
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: const BorderSide(
                                    color: Colors.green,
                                    width: 2,
                                  ), // border tombol
                                ),
                              ),
                              child: Ink(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color.fromARGB(255, 255, 235, 188),
                                      Color.fromARGB(255, 181, 255, 183),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: _isLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        )
                                      : const Text(
                                          "MASUK",
                                          style: TextStyle(
                                            color: Colors
                                                .white, // teks lebih kontras
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            shadows: [
                                              Shadow(
                                                // biar teks lebih menonjol
                                                offset: Offset(0, 1),
                                                blurRadius: 2,
                                                color: Colors.black26,
                                              ),
                                            ],
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),

                          // SizedBox(
                          //   width: double.infinity,
                          //   height: 45,
                          //   child: ElevatedButton(
                          //     style: ElevatedButton.styleFrom(
                          //       // backgroundColor: Colors.grey[400],
                          //       backgroundColor: Color.fromARGB(255, 196, 159, 74),
                          //       shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(10),
                          //       ),
                          //     ),
                          //     onPressed: _isLoading ? null : _login,
                          //     child: _isLoading
                          //         ? const CircularProgressIndicator(
                          //             color: Colors.white,
                          //             strokeWidth: 2,
                          //           )
                          //         : const Text(
                          //             "Masuk",
                          //             style: TextStyle(
                          //               color: Colors.white,
                          //               fontWeight: FontWeight.bold,
                          //             ),
                          //           ),
                          //   ),
                          // ),
                          const Spacer(), // Biar nempel bawah tapi tetap rapi
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
