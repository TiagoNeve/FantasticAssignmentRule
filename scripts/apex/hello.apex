List<Map<String, String>> lista = new List<Map<String, String>>();

lista.add(new Map<String, String>{
    'label' => 'b',
    'value' => 'b'
});

lista.add(new Map<String, String>{
    'label' => 'a',
    'value' => 'a'
});

System.debug(lista);

lista.sort();

System.debug(lista);