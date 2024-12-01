package com.example.KuMeetDemo.Repository;

import com.example.KuMeetDemo.Model.Groups;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface GroupRepository extends MongoRepository<Groups, UUID> {

}
