# Pawz

Aplicacao movel em Flutter para gestao centralizada da saude e bem-estar de animais de estimacao.

## Descricao

O objetivo da Pawz e reunir num unico lugar informacao importante sobre os pets, como dados basicos, historico de saude e apoio contextual ao tutor. Nesta fase, o projeto ja inclui navegacao principal, persistencia local de pets, formulario de registo/edicao, visualizacao de vacinas por pet e um modulo funcional de clinicas veterinarias proximas com mapa.

## Estado atual do projeto

Neste momento, o projeto ja tem implementado:

- Navegacao principal com `BottomNavigationBar` entre `NearbyVetsScreen`, `PetsScreen` e `CalendarScreen`
- App bar partilhada entre o ecra principal de pets e o ecra de veterinarios proximos
- Persistencia local com Hive para `Pet`, `Vaccine`, `Antiparasitic` e `Medication`
- Gestao de estado com `Provider` para carregamento, criacao, edicao e remocao de pets
- Lista de pets guardados localmente
- Criacao e edicao de pets com:
  - nome
  - especie
  - data de nascimento
  - data de adocao
  - peso
  - microchip
  - foto do pet via galeria com `image_picker`
- Acoes sobre cada pet:
  - abrir detalhe
  - editar
  - apagar com confirmacao
- `PetDetailScreen` com tabs `Health`, `Mood` e `Visits`
- Tab `Health` ligada a `VaccineListScreen`
- Leitura de vacinas por pet a partir da box Hive
- Modulo de veterinarios proximos com:
  - obtencao de localizacao do utilizador via `geolocator`
  - mapa com `flutter_map` e OpenStreetMap
  - pesquisa de clinicas na Overpass API
  - pesquisa textual de clinicas por nome ou morada
  - bottom sheet com lista de clinicas
  - recentrar mapa na localizacao do utilizador
  - abrir indicacoes no Google Maps/app de navegacao
  - dialogo com detalhes da clinica
  - toque no marcador do mapa para abrir os detalhes da clinica

## Funcionalidades parciais ou ainda em falta

O README anterior listava varias funcionalidades planeadas que ainda nao estao concluidas no codigo atual. Neste momento:

- `CalendarScreen` ainda esta em placeholder (`Calendar - soon`)
- Tabs `Mood` e `Visits` ainda estao em placeholder no detalhe do pet
- A area de saude ainda so tem listagem de vacinas implementada
- Ainda nao existem ecras funcionais para registo/listagem de antiparasitarios e medicacao
- O botao flutuante de adicionar ja apresenta opcoes, mas apenas a criacao de pet esta funcional
- Os botoes de notificacoes e definicoes ainda nao tem comportamento implementado
- O status dos pets (`Up to Date`, etc.) ainda usa logica placeholder
- O projeto inclui dependencias para notificacoes locais e `timezone`, mas essa integracao ainda nao esta ligada aos fluxos da app

## Estrutura atual de ecras

```text
MainScreen
|-- NearbyVetsScreen
|-- PetsScreen
|   |-- NewPetScreen
|   `-- PetDetailScreen
|       |-- Tab: Health
|       |   `-- VaccineListScreen
|       |-- Tab: Mood (placeholder)
|       `-- Tab: Visits (placeholder)
`-- CalendarScreen (placeholder)
```

## Estrutura principal do projeto

```text
pawz/lib
|-- main.dart
|-- models/
|   |-- pet.dart
|   |-- vaccine.dart
|   |-- antiparasitic.dart
|   |-- medication.dart
|   `-- vet_clinic.dart
|-- providers/
|   `-- pet_provider.dart
|-- screens/
|   |-- main_screen.dart
|   |-- pets_screen.dart
|   |-- new_pet_screen.dart
|   |-- pet_detail_screen.dart
|   |-- vaccine_list_screen.dart
|   |-- nearby_vets_screen.dart
|   `-- calendar_screen.dart
|-- services/
|   `-- overpass_service.dart
`-- widgets/
    |-- pawz_app_bar.dart
    `-- nearby_vets/
```

## Tecnologias utilizadas

| Categoria | Tecnologia |
|---|---|
| Framework | Flutter |
| Linguagem | Dart |
| Gestao de estado | Provider |
| Persistencia local | Hive / hive_flutter |
| Mapas | flutter_map + OpenStreetMap |
| Geolocalizacao | geolocator |
| HTTP | http |
| Navegacao externa | url_launcher |
| Tipografia | google_fonts |
| Imagem | image_picker |
| Notificacoes | flutter_local_notifications |
| Timezone | timezone |

## Como executar

### Requisitos

- Flutter instalado
- Dart compativel com o SDK definido no projeto
- Emulador Android/iOS ou dispositivo fisico

### Passos

1. Entrar na pasta da app:

```bash
cd pawz
```

2. Instalar dependencias:

```bash
flutter pub get
```

3. Gerar ficheiros do Hive, se necessario:

```bash
dart run build_runner build
```

4. Executar a app:

```bash
flutter run
```

## Modelos de dados ja definidos

O projeto ja tem modelos Hive para:

- `Pet`
- `Vaccine`
- `Antiparasitic`
- `Medication`

Atualmente, o fluxo completo implementado na interface trabalha sobretudo com `Pet` e leitura de `Vaccine`.

## Proximos passos sugeridos

- Implementar criacao e edicao de vacinas
- Criar ecras de antiparasitarios e medicacao
- Substituir placeholders de `Mood`, `Visits` e `Calendar`
- Ligar notificacoes locais aos eventos de saude
- Refinar a logica de status de cada pet
- Melhorar tratamento de erros e estados offline no modulo de veterinarios

## Autor

- Nome: Mariana Conde Fidelis
- Numero de Aluno: 86831
- Email Institucional: a86831@ualg.pt
- Curso: Engenharia de Sistemas e Tecnologias Informaticas
- Ano Letivo: 2025/26

## Licenca

Projeto academico mantido em repositorio privado.

Num contexto de codigo aberto, o software poderia ser distribuido sob a licenca MIT, conforme indicado em `LICENSE.md`.

## Referencias

- Flutter Documentation: https://docs.flutter.dev
- Dart Documentation: https://dart.dev/guides
