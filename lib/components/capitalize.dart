//funçao para deixar a primeira letra maiuscula

extension StringExtension on String {
  String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
  String capitalize() {
    return replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
    //return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}