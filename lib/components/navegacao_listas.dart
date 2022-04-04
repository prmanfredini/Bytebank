import 'package:flutter/material.dart';

class BotoesTransf extends StatelessWidget {
  final String nome;
  final IconData icon;
  final Function onClick;

  BotoesTransf(this.nome, this.icon, {required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme.of(context).primaryColor,
        child: InkWell(
          onTap: () {onClick();},
          child: Container(
              width: 110,
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    icon,
                    color: Colors.white,
                    size: 24.0,
                  ),
                  Text(nome,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      )),
                ],
              )),
        ),
      ),
    );
  }
}