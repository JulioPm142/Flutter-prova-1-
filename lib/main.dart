import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => TelaA(),
        '/telaB': (context) => TelaB(),
        '/telaC': (context) => TelaC(),
      },
    );
  }
}

class TelaA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tela A')),
      body: Center(
        child: Column(children: [
          Image.network(
            'https://th.bing.com/th/id/OIP.JvE7ZR0-1Ld9_xi9D5LChAHaEK?rs=1&pid=ImgDetMain',
            width: 300,
            height: 300,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/telaB');
            },
            child: Text('Entrar'),
          )
        ]),
      ),
    );
  }
}

class TelaB extends StatefulWidget {
  @override
  FormsState createState() => FormsState();
}

class FormsState extends State<TelaB> {
  final urlLogin = Uri.parse('http://demo2056710.mockable.io/login');
  String _respLogin = 'semConteudo';

  Future<void> _postLogin(String nome, String senha) async {
    final Map<String, dynamic> data = {
      'nome': nome,
      'senha': senha,
    };

    final response = await http.post(
      urlLogin,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    final Map<String, dynamic> responseData = jsonDecode(response.body);
    print('Dados decodificados: $responseData');
    print(responseData['token']);

    setState(() {
      _respLogin = responseData['token'];
    });
  }

  final TextEditingController _nome = TextEditingController();
  final TextEditingController _senha = TextEditingController();
  String _result = "";
  bool envio = false;

  void _enviar() async {
    String nome = _nome.text;
    String senha = _senha.text;
    void changeEnvio(bool e) {
      setState(() {
        envio = e;
      });
    }

    await _postLogin(nome, senha);
    setState(() {
      if (nome == "" || senha == "") {
        _result = "";
        print('valor nulo');
      } else {
        changeEnvio(true);
        _result = nome + senha;
        print(_result);

        Navigator.pushReplacementNamed(context, '/telaC', arguments: {
          'token': _respLogin,
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tela B')),
      body: Center(
          child: Column(
        children: [
          const SizedBox(height: 20.0),

          const SizedBox(height: 16.0),
          SizedBox(
              width: 300,
              child: TextField(
                controller: _nome,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Entre com nome',
                  prefixIcon: const Icon(Icons.account_circle_outlined),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              )),
          const SizedBox(height: 16.0),
          const SizedBox(height: 16.0),
          SizedBox(
              width: 300,
              child: TextField(
                controller: _senha,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Entre com senha',
                  prefixIcon: const Icon(Icons.account_circle_outlined),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              )),
          !envio
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: (_enviar),
                        child: const Text('Entrar'),
                      ),
                    ],
                  ),
                )
              : const Text('Logado')
        ],
      )),
    );
  }
}

class TelaC extends StatefulWidget {
  @override
  TelaCState createState() => TelaCState();
}

class TelaCState extends State<TelaC> {
  String _filtro = '>';
  int _valor = 0;

  List<dynamic> alunos = [''];

  final urlAlunos = Uri.parse('http://demo2056710.mockable.io/notas');

  Future<void> fetchData() async {
    final responseAlunos = await http.get(urlAlunos);
    if (responseAlunos.statusCode == 200) {
      setState(() {
        alunos = jsonDecode(responseAlunos.body);
      });

      //confirmando que está recebendo as informações corretamente

      alunos.forEach((alunos) {
        print('Matrícula: ${alunos['Matricula']}');
        print('Nome: ${alunos['Nome']}');
        print('Notas: ${alunos['Nota']}');
      });
    } else {
      // erro na requisição
      print('Falha: ${responseAlunos.statusCode}.');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void setFiltro(filtro, valor) {
    setState(() {
      _filtro = filtro;
      _valor = valor;
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final token = arguments?['token'] ?? 'sem item';

    return Scaffold(
      appBar: AppBar(title: Text('Tela C, Token atual: $token')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _filtro == '<'
                  ? alunos.where((aluno) => aluno['Nota'] < _valor).length
                  : alunos.where((aluno) => aluno['Nota'] > _valor).length,
              itemBuilder: (BuildContext context, int index) {
                final alunosFiltrados = _filtro == '<'
                    ? alunos.where((aluno) => aluno['Nota'] < _valor).toList()
                    : alunos.where((aluno) => aluno['Nota'] > _valor).toList();
                final item = alunosFiltrados[index];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: item['Nota'] < 60
                          ? const Color.fromARGB(179, 231, 241, 88) // Vermelho
                          : item['Nota'] < 100
                              ? const Color.fromARGB(
                                  255, 147, 236, 228) // Amarelo
                              : const Color.fromARGB(
                                  144, 114, 244, 114), // Verde
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Matrícula: ' + item['Matricula'].toString(),
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Nome: ' + item['Nome'],
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Nota: ' + item['Nota'].toString(),
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setFiltro('>', 59);
                  },
                  child: Text('>=60'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setFiltro('>', 99);
                  },
                  child: Text('=100'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setFiltro('<', 40);
                  },
                  child: Text('<60'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setFiltro('>', 0);
                  },
                  child: Text('Todos'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
