import '../models/disease_model.dart';

List<DiseaseModel> diseases = [
  DiseaseModel(
    name: "Tomato Yellow Leaf Curl Virus",
    type: "Dangerous",
    scientificName: "TYLCV",
    description:
        "A highly destructive viral disease transmitted by whiteflies. It causes severe leaf curling, intense yellowing, stunted plant growth, and drastic reduction in fruit production. Newly formed leaves become narrow and twisted, and the plant struggles to develop normally.",
    treatment:
        "• Control the whitefly vector (Bemisia tabaci) using protective nets and insect management strategies.\n"
        "• Apply insecticides such as imidacloprid, bifenthrin, or formetanate in rotation to prevent resistance development.\n"
        "• Use yellow sticky traps and reflective mulches to reduce whitefly populations and prevent infestation.\n"
        "• Remove infected plants and eliminate nearby weeds that may host the virus or whiteflies.",
    image: "assets/images/tylcv.jpg",
    symptoms: [
      "Severe leaf curling",
      "Intense yellowing",
      "Stunted growth",
      "Narrow twisted leaves",
      "Reduced fruit production"
    ],
    preventionTips: [
      "Plant resistant/tolerant varieties (TYLCV-resistant)",
      "Use floating row covers to exclude whiteflies",
      "Remove weed hosts nearby",
      "Inspect transplants for whiteflies before planting",
      "Monitor and control whiteflies early in season"
    ],
  ),
  DiseaseModel(
    name: "Tomato Mosaic Virus",
    type: "Moderate",
    scientificName: "ToMV",
    description:
        "A highly persistent virus causing mottled mosaic-like patterns on leaves. Leaves become distorted, narrow, and string-like. Plants exhibit reduced growth, poor fruiting, and leaf curling. ToMV can survive for years on tools, clothes, soil, and debris.",
    treatment:
        "• Immediately remove and destroy infected plants to prevent the virus from spreading to healthy plants.\n"
        "• Maintain strict hygiene by washing hands and sterilizing tools before handling plants.\n"
        "• Grow TMV-resistant tomato varieties to reduce the risk of infection.\n"
        "• Avoid handling tomato plants after touching tobacco products, which may carry the virus.",
    image: "assets/images/tomv.jpg",
    symptoms: [
      "Mottled mosaic patterns",
      "Distorted narrow leaves",
      "Reduced growth",
      "Poor fruiting",
      "Leaf curling"
    ],
    preventionTips: [
      "Plant resistant varieties (TMV-resistant)",
      "Wash hands thoroughly before handling plants",
      "Don't smoke near tomatoes (tobacco can carry virus)",
      "Disinfect stakes, ties, and tools",
      "Remove and destroy infected plants immediately"
    ],
  ),
  DiseaseModel(
    name: "Target Spot",
    type: "Moderate",
    scientificName: "Corynespora cassiicola",
    description:
        "A fungal disease caused by Corynespora cassiicola producing circular brown lesions with concentric rings resembling a target. It thrives in warm and humid conditions, causing rapid defoliation and weakened plant structure.",
    treatment:
        "• Apply strobilurin fungicides such as azoxystrobin or combinations like mancozeb + fenamidone for effective disease management.\n"
        "• Use plant defense activators such as acibenzolar-S-methyl to stimulate the plant's natural immune response.\n"
        "• Include alternative chemical options like BAS 510 02 as part of an integrated fungicide program.\n"
        "• Monitor plants regularly and begin treatments early to reduce defoliation and yield loss.",
    image: "assets/images/target_spot.jpg",
    symptoms: [
      "Circular brown lesions",
      "Concentric rings",
      "Rapid defoliation",
      "Weakened plant structure"
    ],
    preventionTips: [
      "Avoid overhead irrigation",
      "Improve air circulation through pruning/staking",
      "Rotate with non-host crops for 2-3 years",
      "Remove crop debris thoroughly",
      "Use disease-free seeds and transplants"
    ],
  ),
  DiseaseModel(
    name: "Spider Mites",
    type: "Mild",
    scientificName: "Tetranychus urticae",
    description:
        "Tiny sap-sucking pests that feed on the underside of leaves. They create pale-yellow stippling marks and fine silk webs. Heavy infestations lead to leaf yellowing, drying, and dropping. They multiply extremely fast during hot and dry conditions.",
    treatment:
        "• Spray plants with a strong stream of water, especially on the undersides of leaves, to physically remove mites.\n"
        "• Apply insecticidal soap, neem oil, or horticultural oils to control mite populations effectively.\n"
        "• Remove and dispose of heavily infested leaves to reduce the overall mite population.\n"
        "• Use targeted miticides only when infestations are severe and difficult to control.\n"
        "• Encourage beneficial predators such as ladybugs and predatory mites that naturally control spider mites.",
    image: "assets/images/spider_mites.jpg",
    symptoms: [
      "Pale-yellow stippling",
      "Fine silk webs",
      "Leaf yellowing",
      "Leaf drying",
      "Leaf dropping"
    ],
    preventionTips: [
      "Maintain adequate soil moisture (mites prefer dry conditions)",
      "Avoid broad-spectrum insecticides (kill beneficial insects)",
      "Regularly check undersides of leaves",
      "Remove dusty conditions by hosing plants",
      "Remove heavily infested plants promptly"
    ],
  ),
  DiseaseModel(
    name: "Septoria Leaf Spot",
    type: "Moderate",
    scientificName: "Septoria lycopersici",
    description:
        "A common fungal disease producing many small round grey spots with dark edges. It begins on lower leaves and climbs upward over time, causing premature leaf drop. Ideal conditions include rainy seasons and poor air circulation.",
    treatment:
        "• Apply fixed-copper fungicides at the first sign of spotting to protect healthy foliage from further infection.\n"
        "• Use mulch around plants to reduce soil splash that spreads fungal spores onto leaves.\n"
        "• Water plants at the soil level instead of overhead irrigation to keep leaves dry.\n"
        "• Prune the lowest 3-4 leaf branches to increase airflow and reduce humidity around the plant base.\n"
        "• Carefully inspect and select healthy transplants before planting.",
    image: "assets/images/septoria.jpg",
    symptoms: [
      "Small round grey spots",
      "Dark edges on spots",
      "Premature leaf drop",
      "Spreads upward"
    ],
    preventionTips: [
      "Avoid overhead watering",
      "Stake or cage plants for airflow",
      "Practice 3-year crop rotation",
      "Clean up all plant debris in fall",
      "Don't compost infected plants"
    ],
  ),
  DiseaseModel(
    name: "Leaf Mold",
    type: "Mild",
    scientificName: "Passalora fulva",
    description:
        "A fungal disease showing yellow patches on top leaf surfaces and fuzzy green mold underneath. Usually seen in humid greenhouses or densely planted gardens. Leads to leaf drop and reduced fruit yield.",
    treatment:
        "• Improve ventilation and airflow around plants, particularly in greenhouses, to reduce humidity levels that favor fungal growth.\n"
        "• Water plants at the base of the plant to prevent moisture accumulation on leaves.\n"
        "• After fruit development begins, prune lower leaves to enhance airflow and reduce infection risk.\n"
        "• Maintain strict greenhouse hygiene by removing plant debris and disinfecting structures at the end of the season.",
    image: "assets/images/leaf_mold.jpg",
    symptoms: [
      "Yellow patches on top",
      "Fuzzy green mold underneath",
      "Leaf drop",
      "Reduced fruit yield"
    ],
    preventionTips: [
      "Water at base, not overhead",
      "Space plants adequately",
      "Maintain proper plant nutrition",
      "Remove plant debris at season end",
      "Avoid high humidity conditions"
    ],
  ),
  DiseaseModel(
    name: "Late Blight",
    type: "Dangerous",
    scientificName: "Phytophthora infestans",
    description:
        "One of the most severe diseases affecting tomatoes. It produces large water-soaked patches that quickly enlarge, turning brown and killing leaves. Spreads rapidly in cool and wet conditions and can destroy entire crops within days.",
    treatment:
        "• Apply protective fungicides such as chlorothalonil at the first sign of infection to slow disease development.\n"
        "• Use systemic fungicides like metalaxyl for better control when infections are already present.\n"
        "• Remove and destroy infected plants promptly to stop rapid spore production and disease spread.\n"
        "• Integrate resistant varieties, proper humidity management, and timely fungicide sprays for effective disease control.",
    image: "assets/images/late_blight.jpg",
    symptoms: [
      "Large water-soaked patches",
      "Brown dead leaves",
      "Rapid spread",
      "Crop destruction"
    ],
    preventionTips: [
      "Destroy volunteer tomato/potato plants",
      "Avoid overhead watering",
      "Monitor weather forecasts (cool, wet conditions favor disease)",
      "Ensure good air circulation",
      "Plant resistant varieties where available"
    ],
  ),
  DiseaseModel(
    name: "Early Blight",
    type: "Moderate",
    scientificName: "Alternaria solani",
    description:
        "A widespread fungal disease causing circular 'bullseye' spots on older leaves, followed by yellowing and leaf drop. Reduces fruit size and yield because the plant loses photosynthetic area.",
    treatment:
        "• Follow a regular fungicide program by spraying chlorothalonil or mancozeb every 7-10 days to protect foliage from infection.\n"
        "• For active infections, use systemic fungicides such as azoxystrobin to control the spread within the plant.\n"
        "• Treat seeds with Trichoderma and apply foliar sprays of Bacillus subtilis as a biological preventive measure.\n"
        "• Apply mulch around plants and remove infected lower leaves to minimize soil splash and improve air circulation.\n"
        "• Rotate crops for 2-3 years and consider planting resistant varieties such as Roma VF.",
    image: "assets/images/early_blight.jpg",
    symptoms: [
      "Circular bullseye spots",
      "Yellowing leaves",
      "Leaf drop",
      "Reduced fruit size"
    ],
    preventionTips: [
      "Space plants for good air circulation",
      "Water at base, keeping foliage dry",
      "Stake or cage plants to improve airflow",
      "Remove and destroy infected plant debris in fall",
      "Plant resistant varieties where available"
    ],
  ),
  DiseaseModel(
    name: "Bacterial Spot",
    type: "Moderate",
    scientificName: "Xanthomonas campestris",
    description:
        "A bacterial disease causing small, raised black lesions on leaves and scabby spots on fruit. It spreads quickly through water splash and handling wet plants during warm weather.",
    treatment:
        "• Apply fixed-copper fungicides as soon as symptoms appear. These sprays help protect healthy foliage and prevent the spread of the bacteria, although they cannot cure already infected leaves.\n"
        "• Use biological control agents such as Trichoderma or Bacillus species to suppress bacterial growth and strengthen the plant's natural defense system.\n"
        "• Remove and dispose of infected leaves and plant debris immediately to reduce the source of infection.\n"
        "• Control nearby solanaceous weeds (such as nightshade) that can act as reservoirs for the bacteria.",
    image: "assets/images/bacterial_spot.jpg",
    symptoms: [
      "Raised black lesions",
      "Scabby fruit spots",
      "Spreads in wet conditions"
    ],
    preventionTips: [
      "Avoid overhead irrigation; use drip irrigation instead",
      "Don't work in garden when plants are wet",
      "Practice crop rotation with non-solanaceous crops",
      "Remove plant debris at season end",
      "Disinfect tools between plants"
    ],
  ),
];