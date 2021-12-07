package com.example.service;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

@Repository
public interface FruitRepository extends CrudRepository<Fruit, Integer> {
    List<Fruit> findByName(String name);

    default List<Fruit> findAllFruitsByName(String name) {
        return findByName(name);
    }

    @Query("select f from Fruit f where f.name like %?1")
    List<Fruit> findByNameLike(String name);
}
