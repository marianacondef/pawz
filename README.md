# Pawz 🐾
---
> Aplicação móvel para gestão centralizada da saúde e bem-estar de animais de estimação.
#### Autor: Mariana Conde Fidelis | a86831@ualg.pt | 2025/26
---

## 📖 Descrição do Projeto

Pawz é uma aplicação móvel desenvolvida em Flutter que permite aos tutores de animais de estimação centralizar toda a informação de saúde dos seus pets em um único lugar. A aplicação busca resolver um problema de descentralização dos dados veterinários, que normalmente ficam dispersos em cadernetas físicas e documentos avulsos, levando a lacunas e esquecimento por parte dos tutores. 

A Pawz agrega tudo isso numa interface intuitiva, com acesso a veterinários próximos, alertas, calendário de vacinas, antiparasitários e remédios.

### 👥 Público-Alvo

Tutores de animais de estimação (cães, gatos e outros) que querem um diário digital de saúde para um ou múltiplos pets, acessível a qualquer momento no telemóvel.

---

### ✨ Funcionalidades Principais

#### Gestão de Pets
- Registo de animais com nome, espécie, data de nascimento, data de adoção, peso e microchip
- Foto de perfil por pet via câmara ou galeria (`image_picker`)
- Badge de status por animal: *Up to Date*, *Vaccine Due*, *Action Needed* de acordo com o status de saúde do animal (i.e. vacina vencida, marcação de consulta necessária, etc)

#### Calendário Global
- Vista mensal com dots coloridos por tipo de evento (vacina, antiparasitário, consulta, medicação)
- Lista cronológica de eventos com chip do pet associado
- Ação "Mark as Done" por evento

#### Alertas
- Painel acessível pelo ícone de sino
- Agrupado em *Needs Attention* e *Upcoming*
- Filtros por tipo: vacinas, antiparasitários, consultas
- Badge vermelho com contagem de alertas não lidos
- Notificações nativas do sistema operativo via `flutter_local_notifications`

#### Veterinários Próximos
- Mapa interativo com OpenStreetMap (`flutter_map`)
- Geolocalização em tempo real via `geolocator`
- Pesquisa de clínicas veterinárias próximas via Overpass API
- Permissões de localização configuradas para Android e iOS

---

Por pet, estão disponíveis **três abas individuais**: 

#### Saúde
- **Vacinas**: histórico completo com fabricante, lote, clínica, data e próxima dose; cards expansíveis com mais detalhes
- **Antiparasitários**: registo por produto e tipo (oral, tópico, coleira, injetável), com alerta visual quando a próxima aplicação está a 7 dias ou menos
- **Medicação**: lista de medicamentos ativos e passados com dosagem e frequência

#### Humor Diário
- Seletor de 5 estados: Happy, Neutral, Tired, Anxious, Sick
- Campo de notas opcional
- Histórico de humor em lista cronológica

### Visitas
- Histórico de consultas
- Data da próxima consulta 
- Informações do veterinário de preferência


---

### 💻 Tecnologias Utilizadas

| Categoria | Tecnologia |
|---|---|
| Framework | Flutter 3.22+ / Dart 3.4+ |
| Gestão de estado | Provider |
| Persistência local | Hive |
| Notificações | flutter_local_notifications |
| Câmara / Galeria | image_picker |
| Geolocalização | geolocator |
| Mapas | flutter_map + OpenStreetMap |
| Integração externa | Overpass API (veterinários) |
| Design | Inter (Google Fonts), Material 3 |

---

### Estrutura de Ecrãs

```
BottomNav
├── [Pin] NearbyVetsScreen
├── [Home] PetsScreen
│     └── PetDetailScreen
│           ├── Tab: Health
│           │     ├── VaccineListScreen
│           │     ├── AntiparasiticListScreen
│           │     └── MedicationListScreen
│           ├── Tab: Mood
│           └── Tab: Visits
└── [Calendar] CalendarScreen

Global
├── AlertsPanelSheet
└── AddBottomSheet → New Pet / New Vaccine / New Antiparasitic / New Medicine / New Event
```

---


## 🗓️ Cronograma Simplificado
| Entrega Associada | Data | Tarefas principais |
|---|---|---|
| **-** | 17–24 abr | Configurar Flutter, Hive e Provider; definir modelos de dados (Pet, Vaccine, Antiparasitic, Medication); gerar adaptadores Hive; estrutura de navegação com BottomNav + PetDetailScreen; ecrã PetsScreen básico |
| **C1** | 24 abr | App a correr em dispositivo/emulador com pets, pelo menos um sub-ecrã de saúde funcional e persistência em Hive |
| **-** | 24 abr–4 mai | Vacinas, antiparasitários e medicação; badge de status por pet; aba Humor e Visitas; painel de alertas com filtros; notificações nativas (flutter_local_notifications + timezone) |
| **-** | 4–10 mai | CalendarScreen com dots por tipo de evento; lista cronológica + "Mark as Done"; mapa OpenStreetMap + geolocalização; integração Overpass API; permissões nativas |
| **C2V** | 11 mai | Todas as funcionalidades principais visíveis em vídeo; app completa e navegável |
| **-** | 11–17 mai | Foto de perfil (image_picker); AddBottomSheet para todos os eventos; refinamento UI Material 3 + Inter; testes em dispositivo real; correção de bugs |
| **E** | 18 mai | Código, APK/IPA, documentação e README final entregues |




---

## ⚠️ Desafios Técnicos Previstos

**Hive com objetos aninhados** — os modelos têm listas de sub-objetos (ex: `Pet` contém `List<Vaccine>`). Requer adaptadores Hive gerados com `build_runner` e atenção à ordem dos `typeId` para evitar conflitos de deserialização.

**Notificações com timezone** — as funcionalidades de vacinas, remédios e semelhantes requerem notificações de acordo com horário exato. O `flutter_local_notifications` requer o pacote `timezone` para agendar notificações com hora exata.

**Overpass API para veterinários** — a API tem rate limiting, então a query precisa de ser construída corretamente para filtrar `amenity=veterinary` num raio geográfico a partir das coordenadas do utilizador.

**Permissões nativas** — tanto câmara (`image_picker`) como localização (`geolocator`) requerem configuração manual no `AndroidManifest.xml` e `Info.plist`. Sem esta configuração a app crasha em dispositivo real.

**Dots do calendário dinâmicos** — a geração de dots por data requer agregar todos os eventos de todos os pets numa estrutura `Map<DateTime, List<Event>>` eficiente, atualizada sempre que os dados mudam via Provider.

---


> Este README será expandido ao longo do desenvolvimento com instruções de instalação, screenshots, diagramas de arquitetura detalhados e guia de utilização completo.
