package com.example.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/fruits")
public class FruitController {

    @Autowired FruitRepository repository; // Ignore this

    // TODO GET mappings
    @GetMapping
    public List<Fruit> getAll() {
        return repository.findAll();
    }

    @GetMapping("/{id}")
    public Fruit getFruit(@PathVariable("id") Long id) {
        return repository.findById(id).orElse(null);
    }

    // TODO POST mapping
    @PostMapping
    public Fruit createFruit(@RequestBody Fruit fruit) {
        return repository.save(fruit);
    }

    // TODO PUT mapping
    @PutMapping("/{id}")
    public Fruit updateFruit(@PathVariable("id") Long id, @RequestBody Fruit fruit) {
        fruit.setId(id);
        return repository.save(fruit);
    }

    // TODO DELETE mapping
    @DeleteMapping("/{id}")
    public void delete(@PathVariable("id") Long id) {
        repository.deleteById(id);
    }
}
