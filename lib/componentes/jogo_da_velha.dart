import 'dart:math';

import 'package:flutter/material.dart';

class JogoDaVelha extends StatefulWidget {
  const JogoDaVelha({super.key});

  @override
  State<JogoDaVelha> createState() => _JogoDaVelhaState();
}

class _JogoDaVelhaState extends State<JogoDaVelha> {
  List<String> _tabuleiro = List.filled(9, '');
  String _jogador = 'X';
  bool _contraMaquina = false;
  final Random _randonico = Random();
  bool _pensando = false;

  void _iniciarJogo() {
    setState(() {
      _tabuleiro = List.filled(9, '');
      _jogador = 'X';
    });
  }

  void _trocaJogador() {
    setState(() {
      _jogador = _jogador == 'X' ? 'O' : 'X';
    });
  }

  void _mostreDiaLogoVencedor(String vencedor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(vencedor == 'Empate' ? 'Empate' : 'Vencedor: $vencedor'),
          actions: [
            ElevatedButton(
              child: const Text('Reiniciar Jogo'),
              onPressed: () {
                Navigator.of(context).pop();
                _iniciarJogo();
              },
            ),
          ],
        );
      },
    );
  }

  bool _verificaVencedor(String jogador) {
    const posicoesVencedoras = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];
    for (var posicao in posicoesVencedoras) {
      if (_tabuleiro[posicao[0]] == jogador &&
          _tabuleiro[posicao[1]] == jogador &&
          _tabuleiro[posicao[2]] == jogador) {
        _mostreDiaLogoVencedor(jogador);
        return true;
      }
    }
    if (!_tabuleiro.contains('')) {
      _mostreDiaLogoVencedor('Empate');
      return true;
    }
    return false;
  }

  void _jogadaComputador() {
    setState(() {
      _pensando = true;
    });
    Future.delayed(const Duration(seconds: 1), () {
      int movimento;
      do {
        movimento = _randonico.nextInt(9);
      } while (_tabuleiro[movimento] != '');
      setState(() {
        _tabuleiro[movimento] = '0';
        if (!_verificaVencedor(_jogador)) {
          _trocaJogador();
        }
        _pensando = false;
      });
    });
  }

  void _jogada(int index) {
    if (_tabuleiro[index] == '') {
      setState(() {
        _tabuleiro[index] = _jogador;
        if (!_verificaVencedor(_jogador)) {
          _trocaJogador();
          if (_contraMaquina && _jogador == 'O') {
            _jogadaComputador();
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
// Suggested code may be subject to a license. Learn more: ~LicenseLog:902566450.
    double altura = MediaQuery.of(context).size.height * 0.5;
// Suggested code may be subject to a license. Learn more: ~LicenseLog:2268927170.
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Transform.scale(
                scale: 0.6,
                child: Switch(
                  value: _contraMaquina,
                  onChanged: (value) {
                    setState(() {
                      _contraMaquina = value;
                      _iniciarJogo();
                    });
                  },
                ),
              ),
              Text(_contraMaquina ? 'Computador' : 'Humano'),
              const SizedBox(width: 30.0),
              if (_pensando)
                const SizedBox(
                    height: 15.0,
                    width: 15.0,
                    child: CircularProgressIndicator()),
            ],
          ),
        ),
        Expanded(
          flex: 8,
          child: SizedBox(
            width: altura,
            height: altura,
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _jogada(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          _tabuleiro[index],
                          style: const TextStyle(fontSize: 40.0),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ),
        // ignore: prefer_const_constructors
        Expanded(
          child: ElevatedButton(
              onPressed: _iniciarJogo, child: const Text('Reiniciar Jogo')),
        ),
      ],
    );
  }
}