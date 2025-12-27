import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool loading = false;

  // ✅ INISIALISASI GOOGLE SIGN IN (BENAR)
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  // ================= LOGIN EMAIL =================
  Future<void> loginEmail() async {
    try {
      setState(() => loading = true);

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );
      // authStateChanges akan redirect otomatis
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? "Login gagal")));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  // ================= LOGIN GOOGLE =================
  Future<void> loginGoogle() async {
    try {
      // Tambahkan baris di bawah ini:
      // Ini akan "membersihkan" sesi Google Sign-In yang tersangkut di aplikasi
      // sehingga sistem akan selalu memunculkan jendela "Choose an Account" (Pemilih Akun).
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) return; // User membatalkan pemilihan akun

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      // Firebase authStateChanges di main.dart akan otomatis mengarahkan ke HomePage [cite: 3]
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login Google gagal: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Palet Warna Soft (Slate / Blue Gray)
    const primaryColor = Color(0xFF334155); // Slate 700
    const backgroundColor = Color(0xFFF1F5F9); // Slate 100
    const inputFillColor = Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // LOGO HEADER (Lebih Modern)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1), // Transparan halus
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.storefront_rounded, // Icon toko yang lebih modern
                    color: primaryColor,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Selamat Datang",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Masuk ke sistem kasir Anda",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.blueGrey.shade400,
                  ),
                ),
                const SizedBox(height: 32),

                // FORM CARD (Tanpa Card Shadow tebal, lebih clean)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueGrey.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // EMAIL INPUT
                      _buildTextField(
                        controller: email,
                        label: "Email Address",
                        icon: Icons.alternate_email_rounded,
                        inputType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),

                      // PASSWORD INPUT
                      _buildTextField(
                        controller: password,
                        label: "Password",
                        icon: Icons.lock_outline_rounded,
                        isPassword: true,
                      ),
                      const SizedBox(height: 32),

                      loading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: primaryColor,
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // TOMBOL LOGIN UTAMA
                                ElevatedButton(
                                  onPressed: loginEmail,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 2,
                                    shadowColor: primaryColor.withOpacity(0.4),
                                  ),
                                  child: const Text(
                                    "Masuk",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // DIVIDER "ATAU"
                                Row(
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        color: Colors.grey.shade200,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: Text(
                                        "atau",
                                        style: TextStyle(
                                          color: Colors.grey.shade400,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(
                                        color: Colors.grey.shade200,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),

                                // TOMBOL GOOGLE
                                OutlinedButton.icon(
                                  icon: const Icon(
                                    Icons.g_mobiledata,
                                    size: 28,
                                  ),
                                  label: const Text("Lanjut dengan Google"),
                                  onPressed: loginGoogle,
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.black87,
                                    backgroundColor: Colors.grey.shade50,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    side: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // FOOTER REGISTER
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Belum punya akun? ",
                      style: TextStyle(color: Colors.blueGrey.shade400),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterPage(),
                          ),
                        );
                      },
                      child: const Text(
                        "Daftar Sekarang",
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // WIDGET TEXTFIELD HELPER AGAR LEBIH RAPI
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType inputType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: inputType,
      style: const TextStyle(color: Color(0xFF334155)),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.blueGrey.shade400, fontSize: 14),
        prefixIcon: Icon(icon, color: Colors.blueGrey.shade300, size: 22),
        filled: true,
        fillColor: const Color(0xFFF8FAFC), // Sangat muda
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF334155), width: 1.5),
        ),
      ),
    );
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }
}
