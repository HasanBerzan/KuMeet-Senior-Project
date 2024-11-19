package com.example.KuMeetDemo.Repository;

import com.example.KuMeetDemo.Model.UserGroup;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface UserGroupRepository extends MongoRepository<UserGroup, String> {
    Optional<UserGroup> findByUserIdAndGroupId(UUID userId, UUID groupId);
}
